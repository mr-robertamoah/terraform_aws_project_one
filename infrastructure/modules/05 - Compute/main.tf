# Create Key Pair for EC2 Instance
resource "aws_key_pair" "jump_server_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Create EC2 Instance for Jump Server
resource "aws_instance" "jump_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type         = var.jump_server_instance_type
  vpc_security_group_ids = [data.ssm_security_group.jump_server_sg]
  subnet_id             = data.aws_subnet.jumpstart_public_subnet[0].id
  key_name              = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = data.aws_iam_instance_profile.jump_server_instance_profile.name


  lifecycle {
    ignore_changes = [ 
      ami,
      instance_type,
      subnet_id,
      vpc_security_group_ids,
      key_name
    ]
  }

  tags = merge({
    Name = "JumpServer"
  })
}

# Create service discovery for ecr
resource "aws_service_discovery_private_dns_namespace" "app_namespace" {
    name = "${local.prefix}.local"
    description = "Private DNS namespace for ${local.prefix}"
    vpc  = data.ssm_parameter.vpc_id

    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-namespace"
        }
    )

    lifecycle {
        create_before_destroy = true
        ignore_changes = [ 
            name,
            vpc,
            description
         ]
    }
}

# Add service discovery for ecr
resource "aws_service_discovery_service" "app_service" {
    name = "${local.prefix}-ecs-service"
    description = "Service for ${local.prefix}"

    dns_config {
        namespace_id = aws_service_discovery_private_dns_namespace.app_namespace.id
        dns_records {
            type = "A"
            ttl  = 60
        }

        routing_policy = "MULTIVALUE"
    }
    
    health_check_custom_config {
        failure_threshold = 1
    }

    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-ecs-service"
        }
    )

    lifecycle {
        create_before_destroy = true
        ignore_changes = [ 
            name,
            description
         ]
    }
}

# Create ALB
resource "aws_lb" "app_lb" {
    name               = "${local.prefix}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [data.ssm_parameter.alb_sg]
    subnets            = (data.ssm_parameter.public_frontend_subnet_ids != null) ? split(",", data.ssm_parameter.public_frontend_subnet_ids) : []

    enable_deletion_protection = var.environment == "prod" ? true : false

    drop_invalid_header_fields = true

    # access_logs {
    #     bucket  = var.s3_bucket_name
    #     enabled = true
    #     prefix  = "${local.prefix}/alb-logs"
    # }

    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-alb"
        }
    )
}

# Create ALB Target Group
resource "aws_lb_target_group" "app_target_group" {
    name     = "${local.prefix}-tg"
    port     = var.container_port
    protocol = "HTTP"
    vpc_id   = data.ssm_parameter.vpc_id
    target_type = "ip"

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold  = 2
        unhealthy_threshold = 5
        matcher             = "200-399"
    }

    lifecycle {
        create_before_destroy = true
        ignore_changes = [ 
            name,
            port,
            protocol,
            vpc_id,
            target_type
         ]
    }

    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-tg"
        }
    )
}

# Create ALB Listener for HTTPS
resource "aws_lb_listener" "app_listener" {
    load_balancer_arn = aws_lb.app_lb.arn
    port              = var.alb_https_listener_port
    protocol          = "HTTPS"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_target_group.arn
    }

    certificate_arn = data.aws_acm_certificate.certificate.arn

    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-alb-listener"
        }
    )
}

# Create ALB Listener for HTTP
resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.app_lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_target_group.arn
    }

    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-alb-http-listener"
        }
    )
}

# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "app_waf_association" {
    resource_arn = aws_lb.app_lb.arn
    web_acl_arn  = data.ssm_parameter.waf_arn
    depends_on = [aws_lb.app_lb]

    lifecycle {
        create_before_destroy = true
        ignore_changes = [ 
            resource_arn,
            web_acl_arn
         ]
    }
}

# Create ECR Repository
resource "aws_ecr_repository" "app_repo" {
    name = "${local.prefix}-ecr-repo"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
    
    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-ecr-repo"
        }
    )
}

# Create ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
    family                   = var.task_definition_name
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                     = var.cpu
    memory                  = var.memory
    
    container_definitions = jsonencode([
        {
            name      = var.container_name
            image     = "${aws_ecr_repository.app_repo.repository_url}:${var.image_tag}"
            essential = true
        
            portMappings = [
                {
                    containerPort = var.container_port
                    hostPort      = var.host_port
                    protocol      = "tcp"
                }
            ]
        }
    ])
}

# Create ECS Service with Autoscaling and Load Balancing
resource "aws_ecs_service" "ecs_service" {
    name            = var.service_name
    cluster         = aws_ecs_cluster.app_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task_definition.arn
    desired_count   = var.desired_count
    launch_type     = "FARGATE"
    iam_role = aws_iam_role.ecs_task_execution_role.arn

    network_configuration {
        subnets          = [var.jumpstart_private_subnet_id]
        security_groups  = [aws_security_group.ecs_service_sg.id]
        assign_public_ip = true
    }
    
    load_balancer {
        target_group_arn = aws_lb_target_group.app_target_group.arn
        container_name   = var.container_name
        container_port   = var.container_port
    }
    
    depends_on = [aws_lb_listener.app_listener]
}

# Note: Utilize resource created in previous modules (VPC, Subnets, Security Groups, IAM Roles, etc.)
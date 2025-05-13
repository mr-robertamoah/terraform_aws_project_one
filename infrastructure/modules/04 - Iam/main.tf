# Create ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
    name               = "${local.prefix}-ecs-execution-role"
    assume_role_policy = file("${path.root}/Policies/ecs-assume-role-policy.json")
    
    tags               = merge(
        local.tags,
        {
            Name = "${local.prefix}-ecs-execution-role"
        }
    )
}

# Attach permission policies to ECS Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
    for_each = toset(var.ecs_execution_role_policy_arns)
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = each.value
}

# Create ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
    name               = "${local.prefix}-ecs-task-role"
    assume_role_policy = file("${path.root}/Policies/ecs-assume-role-policy.json")
    
    tags               = merge(
        local.tags,
        {
            Name = "${local.prefix}-ecs-task-role"
        }
    )
}

# Attach permission policies to ECS Task Role
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
    for_each = toset(var.ecs_task_role_policy_arns)
    role       = aws_iam_role.ecs_task_role.name
    policy_arn = each.value
}

# Create ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
    name               = "${local.prefix}-ecs-task-execution-role"
    assume_role_policy = file("${path.root}/Policies/ecs-assume-role-policy.json")
    
    tags               = merge(
        local.tags,
        {
            Name = "${local.prefix}-ecs-task-execution-role"
        }
    )
}

# Attach permission policies to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
    for_each = toset(var.ecs_task_execution_role_policy_arns)
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = each.value
}


# Create IAM Role for Jump Server
resource "aws_iam_role" "jump_server_role" {
    name               = "${local.prefix}-jump-server-role"
    assume_role_policy = data.aws_iam_policy_document.jump_server_assume_role_policy.json
    
    tags               = merge(
        local.tags,
        {
            Name = "${local.prefix}-jump-server-role"
        }
    )
}

# Attach permission policies to Jump Server Role
resource "aws_iam_role_policy_attachment" "jump_server_role_policy" {
    for_each = toset(var.jump_server_role_policy_arns)
    role       = aws_iam_role.jump_server_role.name
    policy_arn = each.value
}

# Create an Instance Profile with SSM Permissions for Jump Server
resource "aws_iam_instance_profile" "jump_server_instance_profile" {
    name = "${local.prefix}-jump-server-instance-profile"
    role = aws_iam_role.jump_server_role.name
    
    tags = merge(
        local.tags,
        {
            Name = "${local.prefix}-jump-server-instance-profile"
        }
    )
}

# IAM ROLE TO ALLOW S3 PUT AND GET ACCESS TO S3 FOR LOGGING
resource "aws_iam_role" "s3_access_role" {
    name               = "${local.prefix}-s3-access-role"
    assume_role_policy = file("${path.root}/Policies/s3-assume-role-policy.json")
    
    tags               = merge(
        local.tags,
        {
            Name = "${local.prefix}-s3-access-role"
        }
    )
}

# Attach permission policies to S3 Access Role
resource "aws_iam_role_policy_attachment" "s3_access_role_policy" {
    for_each = toset(var.s3_access_role_policy_arns)
    role       = aws_iam_role.s3_access_role.name
    policy_arn = each.value
}

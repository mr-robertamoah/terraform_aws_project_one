module "storage" {
  source = "./modules/01 - Storage"
  bucket_name = "robert-amoah-go-hard-or-go-home-storage-bucket"
  project_name = var.project_name
  environment = var.environment
}

module "network" {
  source = "./modules/02 - Network"
  vpc_cidr = var.vpc_cidr
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  public_frontend_subnets = var.public_frontend_subnets
  private_backend_subnets = var.private_backend_subnets
  private_database_subnets = var.private_database_subnets
  project_name = var.project_name
  environment = var.environment
}

module "security" {
  source = "./modules/03 - Security"
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.network.vpc_id
  rds_engine = var.rds_engine
}

module "iam" {
  source = "./modules/04 - Iam"
  project_name = var.project_name
  environment = var.environment
  ecs_execution_role_policy_arns = var.ecs_execution_role_policy_arns
  ecs_task_execution_role_policy_arns = var.ecs_task_execution_role_policy_arns
  ecs_task_role_policy_arns = var.ecs_task_role_policy_arns
  jump_server_role_policy_arns = var.jump_server_role_policy_arns
  s3_access_role_policy_arns = var.s3_access_role_policy_arns
}


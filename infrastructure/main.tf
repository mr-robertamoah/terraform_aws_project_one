module "storage" {
  source = "./modules/01 - Storage"
  bucket_name = "robert-amoah-go-hard-or-go-home-storage-bucket"
}

module "network" {
  source = "./modules/02 - Network"
  vpc_cidr = var.vpc_cidr
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  public_frontend_subnets = var.public_frontend_subnets
  private_backend_subnets = var.private_backend_subnets
  private_database_subnets = var.private_database_subnets
}


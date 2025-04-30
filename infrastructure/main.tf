module "storage" {
  source = "./modules/01 - Storage"
  bucket_name = "robert-amoah-go-hard-or-go-home-storage-bucket"
}

module "network" {
  source = "./modules/02 - Network"
  vpc_cidr = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  public_frontend_subnets = {
      subnet1 = {
          cidr_block = "10.0.1.0/24"
      }
      subnet2 = {
          cidr_block = "10.0.2.0/24"
      }
  }
  private_backend_subnets = {
      subnet1 = {
          cidr_block = "10.0.3.0/24"
      }
      subnet2 = {
          cidr_block = "10.0.4.0/24"
      }
  }
  private_database_subnets = {
      subnet1 = {
          cidr_block = "10.0.5.0/24"
      }
      subnet2 = {
          cidr_block = "10.0.6.0/24"
      }
  }
}






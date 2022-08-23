terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }
}

locals {
  location    = "us-west-2"
  name        = "challenge"
  environment = "dev"
  tags = {
    "Key"         = "Challenge"
    "Environment" = "Development"
    "Deployment"  = "Terraform"
  }

}

provider "aws" {
  region = local.location
}


module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "192.16.0.0/16"

  subnet_cidr_block = "192.16.10.0/24"

  subnet_zone = "us-west-2a"

  tags = local.tags
}

module "ec2" {
  source = "./modules/ec2"

  ami = "ami-830c94e3"

  instance_type = "t2.micro"

  instance_subnet_id = module.vpc.subnet_id

  private_ip = ["192.16.10.100"]

  tags = local.tags
}

module "lb" {
  source = "./modules/lb"

  lb_name = "lb-${local.name}-${local.environment}"

  internal = false

  lb_type = "application"

  deletion_protection = false

  bucket_name = "s3-${local.name}-${local.environment}"

  logspace_prefix = "lb-${local.name}-${local.environment}-logs"

  log_enabled = true

  sg = module.ec2.security_groups

  subnet_id = module.vpc.subnet_id

  tags = local.tags
}

module "rds" {
  source = "./modules/rds"

  storage_size = 50

  skip_final_snapshot = true

  engine = "postgresql"

  engine_version = "10.20-R1"

  instance_class = "db.t3.micro"

  db_name = "db-${local.name}-${local.environment}"

  db_username = "dbadmin"

  db_password = "qVjCSE7mJ9"

  tags = local.tags
}
# Main entrypoint


# S3 backend for storing terraform state
# This bucket is manually managed
terraform {
  backend "s3" {
    bucket         = "testbucket-demo1"
    key            = "aspnet/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}


# Local variables
locals {
  account_id = "188172276735"
  region     = "us-east-1"
  deployment = "aspnet"
  key_name   = "MyPubKeys"
}


# Providers
provider "aws" {
  region = local.region
}

# terraform module vpc
module "aspnet_vpc" {
  source     = "./modules/vpcInfra"
  deployment = local.deployment
  region     = local.region
}

# terraform module app
module "aspnet_app" {
  source          = "./modules/appInfra"
  vpc_id          = module.aspnet_vpc.vpc_id
  private_subnets = module.aspnet_vpc.private_subnets
  public_subnets  = module.aspnet_vpc.public_subnets
  key_name        = local.key_name
}

# terraform module cicd
module "aspnet_cicd" {
  source          = "./modules/cicdInfra"
  vpc_id          = module.aspnet_vpc.vpc_id
  private_subnets = module.aspnet_vpc.private_subnets
  public_subnets  = module.aspnet_vpc.public_subnets
  key_name        = local.key_name
}

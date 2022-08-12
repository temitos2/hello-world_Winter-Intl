module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "=2.78.0"
  name    = "${var.deployment}-vpc"

  # Networking configuration
  cidr            = "10.0.0.0/16"
  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.0.0/18", "10.0.64.0/18"]
  public_subnets  = ["10.0.252.0/22", "10.0.248.0/22"]

  # Other configuration
  enable_nat_gateway   = true
  enable_dns_hostnames = true
}

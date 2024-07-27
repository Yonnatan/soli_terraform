data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name = var.vpc_name
  cidr = var.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.tags,
    {
      Terraform = "true"
    }
  )

  public_subnet_tags = var.alb_controller_subnet_tags ? {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/Tester" = "shared"
    "Type" = "Public"
  } : {}

  private_subnet_tags = var.alb_controller_subnet_tags ? {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/Tester" = "shared"
    "Type" = "Private"
  } : {}

}
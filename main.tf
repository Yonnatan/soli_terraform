# Create VPC 1 (Main VPC To Contain most Resources)
module "vpc_1" {
  source               = "./1_cloud_infrastructure/vpc"
  aws_region           = var.aws_region
  vpc_name             = "primary"
  vpc_cidr             = "172.16.0.0/16"
  public_subnet_cidrs  = ["172.16.101.0/24", "172.16.102.0/24"]
  private_subnet_cidrs = ["172.16.1.0/24", "172.16.2.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  alb_controller_subnet_tags = true

  tags = {
    Environment = "primary"
  }
}

# Create VPC 2 (Sub VPC to for Private Link Creation)
module "vpc_2" {
  source               = "./1_cloud_infrastructure/vpc"
  aws_region           = var.aws_region
  vpc_name             = "secondary"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "secondary"
  }
}


# Cloud Infrastructure Module
module "cloud_infrastructure" {
  source     = "./1_cloud_infrastructure"
  aws_region = var.aws_region

  vpc_id             = module.vpc_1.vpc_id
  public_subnet_ids  = module.vpc_1.public_subnet_ids
  private_subnet_ids = module.vpc_1.private_subnet_ids
  update_kubeconfig  = true
}



# Network Configuration Module (2X EC2s , 2X Private Links)
module "ec2_1" {
  source                     = "./2_network_configuration/ec2"
  name_prefix                = "ec2_1" 
  vpc_id                     = module.vpc_1.vpc_id
  default_security_group_id  = module.vpc_1.default_security_group_id
  private_subnet_ids         = module.vpc_1.private_subnet_ids
  private_subnet_cidr_blocks = module.vpc_2.private_subnet_cidr_blocks
  key-pair = "EC2"
}

module "ec2_2" {
  source                     = "./2_network_configuration/ec2"
  name_prefix                = "ec2_2" 
  vpc_id                     = module.vpc_2.vpc_id
  default_security_group_id  = module.vpc_2.default_security_group_id
  private_subnet_ids         = module.vpc_2.private_subnet_ids
  private_subnet_cidr_blocks = module.vpc_1.private_subnet_cidr_blocks
  key-pair = "EC2"
}


module "private_link_vpc1_to_vpc2" {
  source              = "./2_network_configuration/private_link"
  vpc_id              = module.vpc_1.vpc_id 
  peer_vpc_id         = module.vpc_2.vpc_id     
  subnet_ids          = module.vpc_1.private_subnet_ids 
  peer_subnet_ids     = module.vpc_2.private_subnet_ids
  security_group_ids  = [module.ec2_1.security_group_id]
  instance_id         = module.ec2_2.ec2_instance_id  
  name_suffix         = "vpc1Tovpc2"
}

module "private_link_vpc2_to_vpc1" {
  source              = "./2_network_configuration/private_link"
  vpc_id              = module.vpc_2.vpc_id
  peer_vpc_id         = module.vpc_1.vpc_id
  subnet_ids          = module.vpc_2.private_subnet_ids
  peer_subnet_ids     = module.vpc_1.private_subnet_ids
  security_group_ids  = [module.ec2_2.security_group_id]
  instance_id         = module.ec2_1.ec2_instance_id
  name_suffix         = "vpc2Tovpc1"
}
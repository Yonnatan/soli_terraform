provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "alb" {
  source            = "./alb"
  alb_name          = "tester"
  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids
  cluster_name      = var.cluster_name
}

module "cloudfront" {
  source       = "./cloudfront"
  alb_dns_name = module.alb.alb_dns_name
}

module "eks" {
  source            = "./eks"
  eks_cluster_name  = "tester"
  vpc_id            = var.vpc_id
  aws_region        = var.aws_region
  subnet_ids        = var.private_subnet_ids
  update_kubeconfig = var.update_kubeconfig
}

module "eks_deployment" {
  source                 = "./eks_deployment"
  cluster_name           = module.eks.cluster_name
  cluster_endpoint       = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  cluster_namespace      = var.cluster_namespace
  vpc_id                 = var.vpc_id
  public_subnet_ids      = var.public_subnet_ids
  aws_region             = var.aws_region
  alb_arn                = module.alb.alb_arn
  depends_on             = [module.eks]
}
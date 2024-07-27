terraform {
  required_version = ">= 0.13"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
  }
}

# Data sources
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}


# Web Server Deployment
resource "kubectl_manifest" "web_server_deployment" {
  yaml_body = templatefile("${path.module}/deployments/web-server-deployment.yaml", {
    cluster_namespace = var.cluster_namespace
  })
}

# Web Server Service
resource "kubectl_manifest" "web_server_service" {
  yaml_body = templatefile("${path.module}/deployments/web-server-service.yaml", {
    cluster_namespace = var.cluster_namespace
  })
}

#Alb controller dependancy cert-manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.11.0"  # Specify a version

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "aws_iam_role" "alb_controller" {
  name = "eks-alb-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("${path.module}/deployments/IAMPolicy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.load_balancer_controller.arn
  role       = aws_iam_role.alb_controller.name
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_controller.arn
  }

  depends_on = [helm_release.cert_manager]
}

# ingress resource Server Service
resource "kubectl_manifest" "web_server_ingress" {
  yaml_body = templatefile("${path.module}/deployments/web-server-ingress-resource.yaml", {
    cluster_namespace = var.cluster_namespace
    alb_arn = var.alb_arn
  })
}
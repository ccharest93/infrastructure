terraform {
    required_version = ">= 1.0"
    
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">=5.24"
        }
        helm = {
            source  = "hashicorp/helm"
            version = ">= 2.8.0"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = ">= 2.16.1"
        }
    }  
} 

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
} 

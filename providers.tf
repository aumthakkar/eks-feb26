provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "my_eks_cluster_auth" {
  name = aws_eks_cluster.my_eks_cluster.name
}

provider "kubernetes" {
  host = aws_eks_cluster.my_eks_cluster.endpoint

  cluster_ca_certificate = base64decode(aws_eks_cluster.my_eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.my_eks_cluster_auth.token
}

provider "helm" {
  kubernetes = {
    host = aws_eks_cluster.my_eks_cluster.endpoint

    cluster_ca_certificate = base64decode(aws_eks_cluster.my_eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.my_eks_cluster_auth.token
  }
}
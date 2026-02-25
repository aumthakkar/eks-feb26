output "cluster_name" {
  value = aws_eks_cluster.my_eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.my_eks_cluster.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.my_eks_cluster.certificate_authority[0].data
}

output "eks_cluster_version" {
  value = aws_eks_cluster.my_eks_cluster.version
}
data "aws_eks_addon_version" "cw_observability_latest_driver" {
  count = var.create_cloudwatch_controller ? 1 : 0

  addon_name         = "amazon-cloudwatch-observability"
  kubernetes_version = aws_eks_cluster.my_eks_cluster.version

  most_recent = true
}

resource "aws_eks_addon" "cw_observability_controller" {
  count = var.create_cloudwatch_controller ? 1 : 0

  cluster_name  = aws_eks_cluster.my_eks_cluster.name
  addon_name    = "amazon-cloudwatch-observability"
  addon_version = data.aws_eks_addon_version.cw_observability_latest_driver[count.index].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  preserve             = false
  configuration_values = null

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent,
    aws_eks_pod_identity_association.cw_observability_pod_identity_association
  ]

}
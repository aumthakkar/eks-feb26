data "aws_eks_addon_version" "ebs_latest_driver" {

  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.my_eks_cluster.version

  most_recent = true
}

resource "aws_eks_addon" "ebs_controller" {

  cluster_name  = aws_eks_cluster.my_eks_cluster.name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = data.aws_eks_addon_version.ebs_latest_driver.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  preserve             = false
  configuration_values = null

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent,
    aws_eks_pod_identity_association.ebs_eks_pod_identity_association
  ]

}


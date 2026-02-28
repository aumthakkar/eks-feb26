resource "helm_release" "secrets_store_csi_driver" {
  count = var.create_secrets_mgr_driver ? 1 : 0

  name = "${var.name_prefix}-k8s-secrets-store-csi-driver"
  namespace = "kube-system"
  
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart = "secrets-store-csi-driver"
  version    = "1.5.5"

  set = [
    {
      name  = "syncSecret.enabled"
      value = "true"
    },
    {
      name  = "enableSecretRotation"
      value = "true"
    },
  ]

}

data "aws_eks_addon_version" "ascp_addon_latest" {
  count = var.create_secrets_mgr_driver ? 1 : 0
  
  addon_name         = "aws-secrets-store-csi-driver-provider"
  kubernetes_version = aws_eks_cluster.my_eks_cluster.version

  most_recent = true
}

resource "aws_eks_addon" "ascp_addon" {
  count = var.create_secrets_mgr_driver ? 1 : 0

  cluster_name  = aws_eks_cluster.my_eks_cluster.name
  addon_name    = "aws-secrets-store-csi-driver-provider"
  addon_version = data.aws_eks_addon_version.ascp_addon_latest[count.index].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  preserve             = false
  configuration_values = null

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent,
    helm_release.secrets_store_csi_driver
  ]

}








resource "aws_iam_role" "secrets_mgr_role" {
  count = var.create_secrets_mgr_driver ? 1 : 0

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Sid = ""
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.name_prefix}-secrets-mgr-iam-role"
  }
}

resource "aws_iam_policy" "secrets_mgr_policy" {
  count = var.create_secrets_mgr_driver ? 1 : 0

  name        = "${var.name_prefix}-secret-mgr-policy"
  path        = "/"
  description = "My Secret Manager Permissions policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secret_mgr_role_policy_attachment" {
  count = var.create_secrets_mgr_driver ? 1 : 0

  role = aws_iam_role.secrets_mgr_role[count.index].name
  policy_arn = aws_iam_policy.secrets_mgr_policy[count.index].arn
}

resource "aws_eks_pod_identity_association" "secrets_mgr_pod_identity_association" {
  count = var.create_secrets_mgr_driver ? 1 : 0

  cluster_name = aws_eks_cluster.my_eks_cluster.name
  namespace = "kube-system"

  role_arn = aws_iam_role.secrets_mgr_role[count.index].arn
  service_account = "secrets-store-csi-driver-provider-aws"

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent,
    aws_eks_addon.ascp_addon
  ]

}
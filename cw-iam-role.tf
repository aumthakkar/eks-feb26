resource "aws_iam_role" "cw_iam_role" {
  count = var.create_cloudwatch_controller ? 1 : 0

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
    Name = "${var.name_prefix}-cw-observability-iam-role"
  }

}

resource "aws_iam_role_policy_attachment" "cw_obs_role_policy_attachment" {
  count = var.create_cloudwatch_controller ? 1 : 0

  role = aws_iam_role.cw_iam_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  
}

resource "aws_iam_role_policy_attachment" "xray_role_policy_attachment" {
  count = var.create_cloudwatch_controller ? 1 : 0

  role = aws_iam_role.cw_iam_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_eks_pod_identity_association" "cw_observability_pod_identity_association" {
  count = var.create_cloudwatch_controller ? 1 : 0

  cluster_name = aws_eks_cluster.my_eks_cluster.name
  namespace    = "amazon-cloudwatch"

  service_account = "cloudwatch-agent"
  role_arn        = aws_iam_role.cw_iam_role[count.index].arn

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent
  ]
}


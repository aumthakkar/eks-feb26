resource "aws_iam_role" "lbc_iam_role" {
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
    Name = "${var.name_prefix}-lbc-iam-role"
  }
}

data "http" "lbc_iam_policy_raw" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v3.0.0/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "${var.name_prefix}-lbc-iam-role-policy"
  path        = "/"
  description = "LoadBalancer Controller IAM Policy derived from the raw json policy data source"

  policy = data.http.lbc_iam_policy_raw.response_body

  tags = {
    Name = "${var.name_prefix}-lbc-iam-role-policy"
  }
}

resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attachment" {
  role       = aws_iam_role.lbc_iam_role.name
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
}

resource "aws_eks_pod_identity_association" "lbc_pod_identity_association" {
  cluster_name = aws_eks_cluster.my_eks_cluster.name
  namespace    = "kube-system"

  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.lbc_iam_role.arn

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent
  ]
}
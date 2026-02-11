resource "aws_iam_role" "ebs_csi_iam_role" {
  name = "${var.name_prefix}-ebs-csi-iam-role"

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
    Name = "${var.name_prefix}-ebs-csi-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEBSCSIDriverPolicy" {
  role       = aws_iam_role.ebs_csi_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "ebs_eks_pod_identity_association" {
  cluster_name = aws_eks_cluster.my_eks_cluster.name
  namespace    = "kube-system"

  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi_iam_role.arn

  depends_on = [
    aws_eks_addon.eks_pod_identity_agent
  ]
}
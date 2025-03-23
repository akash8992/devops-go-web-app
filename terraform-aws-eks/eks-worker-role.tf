resource "aws_iam_role" "eks_worker_role" {
  name = "eks-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "eks-worker-role"
  }
}

resource "aws_iam_policy_attachment" "worker_node_policy" {
  name       = "worker-node-policy-attachment"
  roles      = [aws_iam_role.eks_worker_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "worker_cni_policy" {
  name       = "worker-cni-policy-attachment"
  roles      = [aws_iam_role.eks_worker_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "worker_ec2_policy" {
  name       = "worker-ec2-policy-attachment"
  roles      = [aws_iam_role.eks_worker_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

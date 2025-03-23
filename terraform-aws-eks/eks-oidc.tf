# Fetch the existing OIDC provider for EKS
data "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

# Fetch the TLS certificate details for the OIDC provider
data "tls_certificate" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

# Only create the OIDC provider if it does not already exist
resource "aws_iam_openid_connect_provider" "eks" {
  count           = length(data.aws_iam_openid_connect_provider.eks.arn) > 0 ? 0 : 1
  url             = module.eks.cluster_oidc_issuer_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}

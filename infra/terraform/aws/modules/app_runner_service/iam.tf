# ----------------------------------------------------------------------------------------------------------------------
# App Runner Service Account Assume Role
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "service_account_role" {
  name = "${local.iam_name_prefix}-ServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "build.apprunner.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = local.normalized_billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# Policies to have ECR access
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "apprunner_ecr_policy" {
  name = "${local.iam_name_prefix}-ECRAccessPolicy"
  role = aws_iam_role.service_account_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = var.container_arn
      }
    ]
  })
}

data "aws_iam_policy_document" "upload_lambda_document" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      format("%s/*", aws_s3_bucket.code_repository.arn)
    ]
  }
}

resource "aws_iam_role_policy" "upload_lambda_policy" {
  name     = "upload-lambda-policy"
  role     = aws_iam_role.upload_lambda_role.id
  policy   = data.aws_iam_policy_document.upload_lambda_document.json
}


resource "aws_s3_bucket" "code_repository" {
  bucket = var.code_repo_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "auto-delete-expired-versions"
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  lifecycle_rule {
    id                                     = "auto-delete-incomplete-after-x-days"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 2
  }
}

# Access policy for the s3 bucket
data "aws_iam_policy_document" "s3_code_repository" {
  statement {
    principals {
      type = "AWS"
      identifiers = var.allow_code_repo_read_access
    }

    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${var.code_repo_name}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "code_repository" {
  count = length(var.allow_code_repo_read_access) == 0 ? 0 : 1

  bucket = aws_s3_bucket.code_repository.id
  policy = data.aws_iam_policy_document.s3_code_repository.json
}

resource "aws_s3_bucket_public_access_block" "primary" {
  bucket = aws_s3_bucket.code_repository.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "code_repository_arn" {
  value = aws_s3_bucket.code_repository.arn
}

locals {
    env = "local"
}

resource "aws_s3_bucket" "this" {
  bucket = "my-tf-test-bucket-lpnu-111"

  tags = {
    Name        = "My bucket-1"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "this2" {
  bucket = "my-tf-test-bucket-lpnu-222"
  tags = {
    Name        = "My bucket-2"
    Environment = local.env
  }
}



module "s3_bucket_frontend" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.9.0"

  bucket = "${module.label.id}-reznichenko"
  # acl    = "private"
  # control_object_ownership = true
  # object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
} 

resource "aws_s3_bucket_policy" "this" {
  bucket = module.s3_bucket_frontend.s3_bucket_id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${module.cdn.cloudfront_origin_access_identity_iam_arns[0]}"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.s3_bucket_frontend.s3_bucket_arn}/*",
    ]
  }
}
resource "aws_s3_bucket" "tatsukoni_terraform_test_v2" {
  bucket        = "tatsukoni-terraform-test-v2"
  force_destroy = "true"

  tags = {
    Name        = "tatsukoni-terraform-test-v2"
    Env         = "test"
    Service     = "test"
  }
}

resource "aws_s3_bucket_cors_configuration" "tatsukoni_terraform_test_v2" {
  bucket = aws_s3_bucket.tatsukoni_terraform_test_v2.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["http://localhost:3000"]
  }
}

resource "aws_s3_bucket_ownership_controls" "tatsukoni_terraform_test_v2" {
  bucket = aws_s3_bucket.tatsukoni_terraform_test_v2.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "tatsukoni_terraform_test_v2" {
  depends_on = [aws_s3_bucket_ownership_controls.tatsukoni_terraform_test_v2]

  bucket = aws_s3_bucket.tatsukoni_terraform_test_v2.id
  access_control_policy {
    grant {
      grantee {
        type = "CanonicalUser"
        id  = "cbea86dfe619ebd19c7a90fad03f93211138a1fa9ec10d04675ff46b262afb5b"
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "WRITE"
    }

    owner {
      id = "cbea86dfe619ebd19c7a90fad03f93211138a1fa9ec10d04675ff46b262afb5b"
    }
  }
}

resource "aws_s3_bucket_request_payment_configuration" "tatsukoni_terraform_test_v2" {
  bucket = aws_s3_bucket.tatsukoni_terraform_test_v2.id
  payer  = "BucketOwner"
}

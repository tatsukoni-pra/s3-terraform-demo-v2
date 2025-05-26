data "aws_canonical_user_id" "current" {}

##########
# tatsukoni-terraform-test-v2
##########
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
        id  = data.aws_canonical_user_id.current.id
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
      id = data.aws_canonical_user_id.current.id
    }
  }
}

resource "aws_s3_bucket_request_payment_configuration" "tatsukoni_terraform_test_v2" {
  bucket = aws_s3_bucket.tatsukoni_terraform_test_v2.id
  payer  = "BucketOwner"
}

##########
# tatsukoni-terraform-test-v3
# デフォルトで作成した場合は、以下の設定になる。
#
# - パブリックアクセスをすべてブロック：オン
# - オブジェクト所有者：
#  - ACL無効
#  - オブジェクト所有者：バケット所有者の強制
##########
resource "aws_s3_bucket" "tatsukoni_terraform_test_v3" {
  bucket        = "tatsukoni-terraform-test-v3"
  force_destroy = "true"

  tags = {
    Name        = "tatsukoni-terraform-test-v3"
    Env         = "test"
    Service     = "test"
  }
}

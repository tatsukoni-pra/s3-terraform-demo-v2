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

##########
# tatsukoni-terraform-test-v4
# デフォルトで作成した場合は、以下の設定になる。
#
# - パブリックアクセスをすべてブロック：オフ
# - オブジェクト所有者：
#  - ACL有効
#  - オブジェクト所有者：オブジェクトライター
# - アクセスコントロールリスト
#  - バケット所有者 (AWS アカウント)にフルコントロール
#  - S3ログ配信グループに読み取りと書き込み
##########
resource "aws_s3_bucket" "tatsukoni_terraform_test_v4" {
  bucket        = "tatsukoni-terraform-test-v4"
  force_destroy = "true"

  tags = {
    Name        = "tatsukoni-terraform-test-v4"
    Env         = "test"
    Service     = "test"
  }
}

# 以下を設定しないと、ACL有効にならず、アクセスコントロールリストの設定に失敗する
# api error AccessControlListNotSupported: The bucket does not allow ACLs
resource "aws_s3_bucket_ownership_controls" "tatsukoni_terraform_test_v4" {
  bucket = aws_s3_bucket.tatsukoni_terraform_test_v4.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "tatsukoni_terraform_test_v4" {
  # 先に aws_s3_bucket_ownership_controls を設定しないと適用に失敗するため、depends_on の記述が必要
  depends_on = [aws_s3_bucket_ownership_controls.tatsukoni_terraform_test_v4]

  bucket = aws_s3_bucket.tatsukoni_terraform_test_v4.id
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

# パブリックアクセスをすべてブロック：オフ に設定する
resource "aws_s3_bucket_public_access_block" "tatsukoni_terraform_test_v4" {
  bucket                  = aws_s3_bucket.tatsukoni_terraform_test_v4.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

##########
# tatsukoni-terraform-test-v5
# デフォルトで作成した場合は、以下の設定になる。
#
# - パブリックアクセスをすべてブロック：オフ
# - バケットポリシーを設定
##########
resource "aws_s3_bucket" "tatsukoni_terraform_test_v5" {
  bucket        = "tatsukoni-terraform-test-v5"
  force_destroy = "true"

  tags = {
    Name        = "tatsukoni-terraform-test-v5"
    Env         = "test"
    Service     = "test"
  }
}

resource "aws_s3_bucket_public_access_block" "tatsukoni_terraform_test_v5" {
  bucket                  = aws_s3_bucket.tatsukoni_terraform_test_v5.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "tatsukoni_terraform_test_v5" {
  bucket = aws_s3_bucket.tatsukoni_terraform_test_v5.id
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2OT7O0UL6JNKN"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::tatsukoni-terraform-test-v5/*"
        }
    ]
}
EOF
}

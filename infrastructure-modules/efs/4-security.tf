data "aws_iam_policy_document" "this" {
  statement {
    sid    = "${var.env}-efs-policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite",
                "elasticfilesystem:ClientMount"]

    resources = [aws_efs_file_system.this.arn]
    condition {
          test     = "Bool"
          variable = "elasticfilesystem:AccessedViaMountTarget"
          values   = ["true"]
        }
        
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  policy         = data.aws_iam_policy_document.this.json
} 

resource "aws_security_group" "this" {
  name        = "${var.env}-efs-sg"
  description = "EFS mount targets security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.subnet_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.subnet_cidr_block]
  }
}
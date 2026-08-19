resource "aws_iam_user" "ampcode" {
  name = "ampcode"
}

data "aws_iam_policy_document" "ampcode_cloudtrail_read_only" {
  statement {
    sid = "ListTrails"

    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:ListTrails",
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadTrailMetadata"

    actions = [
      "cloudtrail:GetEventSelectors",
      "cloudtrail:GetInsightSelectors",
      "cloudtrail:GetTrail",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:ListTags",
    ]
    resources = ["arn:${data.aws_partition.current.partition}:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
  }
}

resource "aws_iam_user_policy" "ampcode_cloudtrail_read_only" {
  name   = "cloudtrail-trail-metadata-read-only"
  user   = aws_iam_user.ampcode.name
  policy = data.aws_iam_policy_document.ampcode_cloudtrail_read_only.json
}

resource "aws_iam_access_key" "ampcode" {
  user = aws_iam_user.ampcode.name
}

output "ampcode_access_key_id" {
  value = aws_iam_access_key.ampcode.id
}

output "ampcode_secret_access_key" {
  value     = aws_iam_access_key.ampcode.secret
  sensitive = true
}

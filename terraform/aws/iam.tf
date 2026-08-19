resource "aws_iam_user" "ampcode" {
  name = "ampcode"
}

resource "aws_iam_user_policy_attachment" "ampcode_read_only" {
  user       = aws_iam_user.ampcode.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/ReadOnlyAccess"
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

resource "aws_iam_role" "ec2_ssm_role" {
  name = "devops-bootcamp-ec2-ssm-role-${var.yourname}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devops-bootcamp-ec2-profile-${var.yourname}"
  role = aws_iam_role.ec2_ssm_role.name
}

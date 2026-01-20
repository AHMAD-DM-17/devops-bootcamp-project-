resource "aws_ecr_repository" "final_project" {
  name                 = "devops-bootcamp/final-project-${var.yourname}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

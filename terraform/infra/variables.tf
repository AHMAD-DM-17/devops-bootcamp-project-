variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "yourname" {
  type    = string
  default = "ahmadafif"
}

variable "key_name" {
  type        = string
  description = "EC2 KeyPair name in AWS."
  default     = "AhmadAfifKey"
}

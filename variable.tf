variable "webapp-cird-block" {
  type        = string
  default     = "170.31.0.0/16"
  description = "cird block for web app"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "US-EAST(North Virginia)"
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["170.31.1.0/24", "170.31.2.0/24", "170.31.101.0/24", "170.31.102.0/24"]
}

variable "ipv4_any_source" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ipv6_any_source" {
  type    = string
  default = "::0/0"
}

variable "tcp_protocol_type" {
  type    = string
  default = "tcp"
}

variable "instance-ami" {
  type        = string
  default     = "ami-000750b86ae489780"
  description = "Amazon Linux-x86_64-2019-06-12-ebs-hvm-ENA enabled: Yes"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}
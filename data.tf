data "aws_availability_zones" "az" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "http" "local-ip" {
  url = "http://ipv4.icanhazip.com"
}
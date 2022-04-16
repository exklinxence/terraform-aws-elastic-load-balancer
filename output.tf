output "key_pair" {
  value       = aws_key_pair.task1-key
  description = "Keys to ssh into instance"
  sensitive   = false
}

output "web1_instance_public_dns" {
  value       = aws_instance.app1.public_dns
  description = "aws instance public dns"
}

output "web1_instance_public_ip" {
  value       = aws_instance.app1.public_ip
  description = "aws instance public ip"
}
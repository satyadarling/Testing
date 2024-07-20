provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "example" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
}

output "instance_ips" {
  value = aws_instance.example.*.public_ip
}

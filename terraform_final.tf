provider aws {
    region = "us-east-1"
}
resource "aws_instance" "healthcare-server" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.medium"
  key_name = "ubuntu-keypair.pem"
  vpc_security_group_ids= ["sg-09ab4eda7c57a0d8b"]

   tags = {
    Name = "healthcare-server"
  }
}

output "healthcare-server_public_ip" {

  value = aws_instance.healthcare-server.public_ip
  
}

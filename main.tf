provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "allow_http" {
  name_prefix = "terraform-example-"
  description = "Allow HTTP traffic"
  vpc_id      = "vpc-02ffdc165eb7496b7"  # Replace with your VPC ID # done

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "terraformt1.pem"  # Ensure you have a key pair created in your AWS account # done
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install git httpd -y
              systemctl start httpd
              systemctl enable httpd
              cd /var/www/html
              git clone https://github.com/Samiboiii04/my-own-website.git .
              EOF

  tags = {
    Name = "TerraformWebServer"
  }
}

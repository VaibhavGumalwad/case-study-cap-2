# Jenkins Server EC2 Instance
resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  key_name                    = "keypair"

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y openjdk-11-jdk docker.io ansible git
    
    # Install Jenkins
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt update -y
    apt install -y jenkins
    
    # Configure Docker and Jenkins
    usermod -a -G docker jenkins
    systemctl start jenkins
    systemctl enable jenkins
    systemctl start docker
    systemctl enable docker
    
    # Install Terraform
    wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
    unzip terraform_1.6.0_linux_amd64.zip
    mv terraform /usr/local/bin/
  EOF

  tags = {
    Name = "jenkins-server"
  }
}

# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# Elastic IP for Jenkins
resource "aws_eip" "jenkins_ip" {
  tags = {
    Name = "jenkins-eip"
  }
}

# Associate EIP with Jenkins instance
resource "aws_eip_association" "jenkins_eip_assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins_ip.id
}

# Output Jenkins IP
output "jenkins_public_ip" {
  description = "Public IP of Jenkins server"
  value       = aws_eip.jenkins_ip.public_ip
}

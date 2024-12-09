# Provider configuration
provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

# Define a security group
resource "aws_security_group" "web_sg" {
  name        = "studentpk-web-sg"
  description = "Allow HTTP, SSH, ICMP (ping), and custom Node.js application traffic"

  # Allow SSH traffic (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  # Allow HTTP traffic (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  # Allow traffic to Node.js backend (port 3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }

  # Allow traffic to Node.js frontend (port 3001)
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }

  # Allow ICMP (ping) traffic
  ingress {
    from_port   = -1   # ICMP protocol uses -1 for both inbound and outbound
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ping from anywhere
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Launch an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-04dd23e62ed049936"  # Replace with a valid AMI ID for your region
  instance_type = "t3.large"               # Free tier eligible instance type
  key_name      = "studentpk-key"           # Reference the existing key pair by its name
  security_groups = [aws_security_group.web_sg.name]  # Reference the security group

  # Bootstrap script to install eksctl, AWS CLI, kubectl, Git, Docker, and configure permissions
  user_data = <<-EOF
    #!/bin/bash
    # Update packages and install required dependencies
    sudo apt update -y && sudo apt install -y curl unzip tar git sudo

    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # Verify AWS CLI installation
    aws --version

    # Install eksctl
    curl -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" -o eksctl.tar.gz
    tar -xzf eksctl.tar.gz
    sudo mv eksctl /usr/local/bin

    # Verify eksctl installation
    eksctl version

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Verify kubectl installation
    kubectl version --client

    # Install Docker
    sudo apt update -y
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    # Verify Docker installation
    docker --version

    # Pull Docker images for Node.js applications
    sudo docker pull prashanth153/nodejs-backend
    sudo docker pull prashanth153/nodejs-frontend

    # Run the backend Node.js application container
    sudo docker run -d -p 3000:3000 --name nodejs-backend prashanth153/nodejs-backend:latest

    # Run the frontend Node.js application container
    sudo docker run -d -p 3001:3001 --name nodejs-frontend prashanth153/nodejs-frontend:latest

    # Create a folder for Node.js projects
    sudo mkdir -p /home/ubuntu/nodejs

    # Add the ubuntu user to the docker group
    sudo usermod -aG docker ubuntu

    # Clone Git repositories into the nodejs directory
    sudo git clone https://github.com/UnpredictablePrashant/learnerReportCS_frontend /home/ubuntu/nodejs/learnerReportCS_frontend
    sudo git clone https://github.com/UnpredictablePrashant/learnerReportCS_backend /home/ubuntu/nodejs/learnerReportCS_backend

    # Fix permissions for the cloned directories
    sudo chown -R ubuntu:ubuntu /home/ubuntu/nodejs
  EOF

  tags = {
    Name = "terraform-studentpk-bootstrap"
  }
}

#!/bin/bash

echo "========================================="
echo "Setting up FallsPaper on AWS EC2"
echo "========================================="

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
echo "📦 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

# Enable Docker to start on boot
echo "🚀 Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Install Nginx
echo "🌐 Installing Nginx..."
sudo apt-get install -y nginx

# Install Git
echo "📚 Installing Git..."
sudo apt-get install -y git

echo ""
echo "✅ Installation complete!"
echo ""
echo "⚠️  IMPORTANT: Log out and back in for docker group changes to take effect"
echo ""
echo "Next steps:"
echo "1. exit"
echo "2. ssh back into the server"
echo "3. Clone your repository"
echo "4. Follow the deployment guide"

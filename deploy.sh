#!/bin/bash

echo "🚀 Starting Terraform + Ansible + Jenkins Pipeline Deployment"

# Step 1: Deploy Infrastructure with Terraform
echo "📋 Step 1: Deploying Infrastructure..."
cd infra
terraform init
terraform plan
terraform apply -auto-approve

# Get outputs
APP_IP=$(terraform output -raw public_ip)
JENKINS_IP=$(terraform output -raw jenkins_public_ip)

echo "✅ Infrastructure deployed!"
echo "📍 App Server IP: $APP_IP"
echo "📍 Jenkins Server IP: $JENKINS_IP"

# Step 2: Update Ansible inventory
echo "📋 Step 2: Updating Ansible inventory..."
cd ../ansible
cat > hosts.ini << EOF
[app]
$APP_IP ansible_user=ubuntu
EOF

echo "✅ Ansible inventory updated!"

# Step 3: Wait for Jenkins to be ready
echo "📋 Step 3: Waiting for Jenkins server to be ready..."
echo "🔗 Jenkins will be available at: http://$JENKINS_IP:8080"
echo "⏳ This may take 5-10 minutes for initial setup..."

# Step 4: Display next steps
echo ""
echo "🎯 Next Steps:"
echo "1. Access Jenkins at: http://$JENKINS_IP:8080"
echo "2. Get initial admin password: ssh ubuntu@$JENKINS_IP 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword'"
echo "3. Configure Jenkins credentials (DockerHub, AWS, SSH)"
echo "4. Create pipeline job with Jenkinsfile-terraform"
echo "5. Run the pipeline to deploy your application"
echo ""
echo "📱 Your application will be available at: http://$APP_IP"

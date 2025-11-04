#!/bin/bash

# Script to update Ansible inventory with Terraform outputs
APP_IP=$(terraform output -raw public_ip)

# Update hosts.ini
cat > ansible/hosts.ini << EOF
[app]
$APP_IP ansible_user=ubuntu
EOF

echo "✅ Updated hosts.ini with IP: $APP_IP"

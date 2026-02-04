#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/terraform"
ANS_DIR="${ROOT_DIR}/ansible"

echo "==> Terraform init/apply..."
cd "$TF_DIR"
terraform init -upgrade
terraform apply -auto-approve

VM_IP=$(terraform output -raw vm_public_ip)
echo "==> VM Public IP: $VM_IP"

echo "==> Generate Ansible inventory..."
sed "s/\${VM_IP}/${VM_IP}/g" "${ANS_DIR}/inventory.ini.tpl" > "${ANS_DIR}/inventory.ini"

echo "==> Run Ansible..."
cd "$ANS_DIR"
ansible-playbook -i inventory.ini playbook.yml

echo ""
echo "✅ DONE!"
echo "Jenkins UI: http://${VM_IP}:8080  (user: admin)"
echo "App URL (after pipeline runs): http://${VM_IP}:8000"
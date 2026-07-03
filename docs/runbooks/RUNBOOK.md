# HelixScale: Runbook draft version

make tf-init
make tf-plan
ENV=local_node1 make tf-apply

ping -c 1 helixscale-controller.orb.local

ping -c 1 192.168.139.118


#if VM name is change or removed to restart 
terraform state rm module.worker2.orbstack_machine.vm 

terraform import module.worker2.orbstack_machine.vm helixscale-worker2

# trouble recreating vms run
terraform state rm module.controller.orbstack_machine.vm
terraform state rm module.worker1.orbstack_machine.vm
rm terraform.tfstate

# Create VMs on Node 1 using terraform comands
cd infra/node1
Terraform init
Terraform validate
Terraform plan
Terraform apply -auto-approve -parallelism=1


python3 -m venv ~/.venv/ansible && source ~/.venv/ansible/bin/activate
pip install ansible ansible-lint
ansible-galaxy collection install community.general ansible.posix kubernetes.core
ansible -i infra/ansible/inventory.ini all -m ping   # verify connectivity

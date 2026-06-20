# Step 1: Provision the raw virtual hardware nodes
cd infra/node1 && terraform apply -auto-approve
cd ../node2   && terraform apply -auto-approve

# Step 2: Configure OS constraints & install K3s via network SSH
cd ../ansible
ansible-playbook -i inventory_node1.ini -i inventory_node2.ini playbook.yml

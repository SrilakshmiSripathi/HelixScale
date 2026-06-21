# HelixScale: Runbook draft version


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

# HelixScale: Runbook


#if VM name is change or removed to restart 
terraform state rm module.worker2.orbstack_machine.vm 

terraform import module.worker2.orbstack_machine.vm helixscale-worker2

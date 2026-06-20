output "name" {
  value       = orbstack_machine.vm.name
  description = "The hostname of the provisioned VM."
}

output "ip" {
  value       = orbstack_machine.vm.ip_address
  description = "The local IP address assigned to the VM by OrbStack."
}

output "id" {
  value       = orbstack_machine.vm.id
  description = "The unique identifier of the OrbStack machine."
}

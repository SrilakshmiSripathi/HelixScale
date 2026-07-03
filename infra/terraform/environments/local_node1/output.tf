output "controller_name" {
  value       = module.controller.name
  description = "The hostname of the provisioned controller VM."
}

output "controller_ip" {
  value       = module.controller.ip
  description = "The local IP address assigned to the controller VM by OrbStack."
}

output "worker1_name" {
  value       = module.worker1.name
  description = "The hostname of the provisioned worker1 VM."
}

output "worker1_ip" {
  value       = module.worker1.ip
  description = "The local IP address assigned to the worker1 VM by OrbStack."
}

output "cluster_topology_node1" {
  value = {
    controller = {
      vm_name    = module.controller.name
      ip_address = module.controller.ip
      placement  = "Node 1 (M1 Max)"
    }
    worker_1 = {
      vm_name    = module.worker1.name
      ip_address = module.worker1.ip
      placement  = "Node 1 (M1 Max)"
    }
  }
  description = "This maps complete Node 1 pipeline cluster topology."
}

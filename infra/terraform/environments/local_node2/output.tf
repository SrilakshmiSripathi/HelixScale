output "worker2_name" {
  value       = module.worker2.name
  description = "The hostname of the provisioned worker2 VM."
}

output "worker2_ip" {
  value       = module.worker2.ip
  description = "The local IP address assigned to the worker2 VM by OrbStack."
}

output "cluster_topology_node2" {
  value = {
    worker_2 = {
      vm_name    = module.worker2.name
      ip_address = module.worker2.ip
      placement  = "Node 2 (M5 Max)"
    }
  }
  description = "This maps complete Node 2 pipeline cluster topology."
}

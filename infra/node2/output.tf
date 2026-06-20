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

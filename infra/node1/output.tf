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

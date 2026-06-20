# ── Dynamic Ansible Inventory Fragment Generation ─────────────────────────────
resource "local_file" "ansible_inventory_node1" {
  filename = "${path.module}/../ansible/inventory_node1.ini"
  content  = <<EOT
[controllers]
controller ansible_host=${module.controller.ip}
[worker1]
worker1 ansible_host=${module.worker1.ip}
EOT
}

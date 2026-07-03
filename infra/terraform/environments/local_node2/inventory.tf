resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../ansible/inventory/static/inventory.ini.tftpl", {
    worker2_ip = module.worker2.ip
  })
  filename = "${path.module}/../../ansible/inventory/static/inventory_node2.ini"
}

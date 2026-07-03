resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../ansible/inventory/static/inventory.ini.tftpl", {
    controller_ip = module.controller.ip # Or whatever output exposes the IP
    worker1_ip    = module.worker1.ip
  })
  filename = "${path.module}/../../ansible/inventory/static/inventory.ini"
}

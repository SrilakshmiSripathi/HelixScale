terraform {
  required_providers {
    orbstack = {
      source  = "robertdebock/orbstack"
      version = "~> 3.0"
    }
  }
}

resource "orbstack_machine" "vm" {
  name  = var.name
  arch  = var.arch
  image = var.image
}

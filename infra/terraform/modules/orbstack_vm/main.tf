terraform {
  required_version = ">= 1.5.0"
  required_providers {
    orbstack = {
      source  = "robertdebock/orbstack"
      version = "~> 3.1.2"
    }
  }
}

resource "orbstack_machine" "vm" {
  name  = var.name
  arch  = var.arch
  image = var.image
}

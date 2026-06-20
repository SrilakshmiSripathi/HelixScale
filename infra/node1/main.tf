terraform {
  required_providers {
    orbstack = {
      source  = "robertdebock/orbstack"
      version = "~> 3.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
    }
    ansible = {
      version = "~> 1.4.0"
      source  = "ansible/ansible"
    }
  }
}

provider "orbstack" {}
provider "tailscale" {
  api_key = var.tailscale_api_key
}

# ── Headless Device Pre-Authorization Key ─────────────────────────────────────
resource "tailscale_tailnet_key" "vm_auth_key" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 3600 # 1 hour validity window
}

# ── Controller VM ─────────────────────────────────────────────
module "controller" {
  source = "../terraform/modules/orbstack_vm"
  name   = "hs-controller"
}

# ── Worker 1 VM ───────────────────────────────────────────────
module "worker1" {
  source = "../terraform/modules/orbstack_vm"
  name   = "hs-worker1"
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    orbstack = {
      source  = "robertdebock/orbstack"
      version = "~> 3.1.2"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
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
  tags = [
    "tag:helixscale-cluster"
  ]
}

# ── Controller VM ─────────────────────────────────────────────
module "controller" {
  source = "../../modules/orbstack_vm"
  name   = "helixscale-controller"
}

# ── Worker 1 VM ───────────────────────────────────────────────
module "worker1" {
  source = "../../modules/orbstack_vm"
  name   = "helixscale-worker1"
}

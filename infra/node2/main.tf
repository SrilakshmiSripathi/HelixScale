terraform {
  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
    }
    orbstack = {
      source  = "robertdebock/orbstack"
      version = "~> 3.1.2"
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
  expiry        = 3600 # 1 hour expiration
  tags = [
    "tag:helixscale-cluster",
    "tag:automation"
  ]
}

# ── Worker 2 VM ───────────────────────────────────────────────
module "worker2" {
  source = "../terraform/modules/orbstack_vm"
  name   = "helixscale-worker2"
}

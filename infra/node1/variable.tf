variable "default_disk_gb" {
  description = "Default disk size for OrbStack VMs in GB"
  type        = number
  default     = 100
}

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "API key for your Tailnet authentication fabric."
}

variable "name" {
  type        = string
  description = "The hostname of the VM"
  default     = "helixscale-node1"
}
variable "arch" {
  type        = string
  default     = "arm64"
  description = "The host architecture"
}
variable "image" {
  type        = string
  default     = "rocky:9"
  description = "VM operating System"
}
variable "tailscale_api_key" {
  type        = string
  description = "Tailscale API Key"
  sensitive   = true
}

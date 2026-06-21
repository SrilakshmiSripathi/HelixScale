variable "name" {
  type        = string
  description = "The hostname of the VM"
}

variable "arch" {
  type        = string
  default     = "arm64" # Optimized for your Mac M1/M5 Max setup
  description = "The host architecture"
}

variable "image" {
  type        = string
  default     = "rocky:9"
  description = "VM operating System"
}

variable "disk_size" {
  type = number
  default = 100
  description = "Max Disk usage"
}

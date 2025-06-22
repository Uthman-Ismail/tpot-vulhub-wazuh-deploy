variable "proxmox_api_url" {
  description = "The URL of the Proxmox API."
  type        = string
}

variable "proxmox_username" {
  description = "The Proxmox username."
  type        = string
}

variable "proxmox_password" {
  description = "The Proxmox password."
  type        = string
  sensitive   = true
}

variable "proxmox_host" {
  description = "The node of the proxmox."
}

variable "template_name" {
  description = "The Proxmox template used for the vms."
}

variable "ansible_ssh_key" {
  description = "The ssh key ansible."
}



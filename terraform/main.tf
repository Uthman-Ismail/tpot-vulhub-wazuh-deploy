variable "vm_count" {
  type    = number
  default = 1
}

resource "proxmox_vm_qemu" "tpot_vm" {
        count       = var.vm_count
        name        = "tpot-vm-${count.index + 1}"
        target_node = var.proxmox_host
        clone = var.template_name
        agent = 1
        os_type = "cloud-init"
        cores = 8
        sockets = 1
        vcpus = 0
        cpu = "host"
        memory = 16384
        scsihw = "virtio-scsi-pci"
        bootdisk = "order=scsi0"

        disks {
                ide{
                        ide2{
                                cloudinit {
                                        storage = "local-lvm"
                                }
                        }
                }
                scsi {
                        scsi0 {
                                disk {
                                        storage = "local-lvm"
                                        size = "64G"
                                        cache = "writeback"
                                        replicate = true
                                }
                        }
                }
        }

        network {
                model = "virtio"
                bridge = "vmbr0"
        }

        lifecycle {
                ignore_changes = [
                        network,
                ]
        }

	serial { 
        id = 0
        type   = "socket"
        }

        ipconfig0 = "ip=10.1.20.${191 + count.index}/24,gw=10.1.20.1"

        sshkeys = <<EOF
                        ${var.ansible_ssh_key}
                EOF
        ciuser = "uthman"
        cipassword = "1234"

}



resource "proxmox_vm_qemu" "wazuh" {
        name = "wazuh-1"
        target_node = var.proxmox_host
        clone = var.template_name
        agent = 1
        os_type = "cloud-init"
        cores = 2
        sockets = 1
        vcpus = 0
        cpu = "host"
        memory = 4096
        scsihw = "virtio-scsi-pci"
        bootdisk = "order=scsi0"

        disks {
                ide{
                        ide2{
                                cloudinit {
                                        storage = "local-lvm"
                                }
                        }
                }
                scsi {
                        scsi0 {
                                disk {
                                        storage = "local-lvm"
                                        size = "40G"
                                        cache = "writeback"
                                        replicate = true
                                }
                        }
                }
        }

        network {
                model = "virtio"
                bridge = "vmbr0"
        }

        lifecycle {
                ignore_changes = [
                        network,
                ]
        }

        serial { 
        id = 0
        type   = "socket"
        }

        ipconfig0 = "ip=10.1.20.195/24,gw=10.1.20.1"

        ciuser = "uthman"
        cipassword = "1234"

}

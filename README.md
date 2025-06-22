
# Automated Honeypot Deployment with Centralized SIEM Integration

This project delivers a modular, automated honeynet using **Terraform**, **Ansible**, **T-Pot**, **Vulhub**, and **Wazuh**. It supports selective service deployment, CVE simulation, centralized log collection, and real-time attack monitoring. The architecture is designed to scale across virtual network segments and has been tested on an internet-facing environment.

---

## Deployment Walkthrough Video

A full demonstration of the setup process — from VM provisioning and T-Pot customization to Vulhub integration and Wazuh log analysis — is available here:

[`/media/deployment-demo.mp4`](./media/deployment-demo.mp4)

---

## System Requirements

| Resource       | Minimum                         | Recommended                        |
|----------------|----------------------------------|------------------------------------|
| CPU            | 4 cores                          | 8 threads                          |
| Memory         | 12 GB RAM                        | 16 GB RAM                          |
| Disk Space     | 40 GB (SSD preferred)            | 60+ GB if running multiple VMs     |
| Host OS        | Proxmox VE 7.x or later          |                                    |
| Network        | At least 1 public and 1 internal bridge (e.g., `vmbr0`, `vmbr1`) |

Note: Running T-Pot and Vulhub containers in parallel is resource-intensive. Under-provisioned environments may experience log delays or service crashes.

---

## System Overview

- Proxmox VE: Virtualization backend
- Terraform: Honeypot VM provisioning using Cloud-Init
- Ansible: Automated configuration for each VM (services + CVEs)
- Logstash and Wazuh: Log aggregation, enrichment, and alerting

---

## Tools Used

- Terraform – Infrastructure as Code
- Ansible – Configuration management
- T-Pot – Modular honeypot platform
- Vulhub – Containerized CVEs for threat simulation
- Wazuh – SIEM for alerts, dashboards, and correlation

---

## Deployment Process

### 1. Cloud-Init Base VM

Prepare an Ubuntu base image in Proxmox with Cloud-Init enabled:
- Create a default user with SSH access
- Install Docker in the base image
- Optionally preload system packages

### 2. Terraform Configuration

Install Terraform:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
terraform -install-autocomplete
```

Customize `main.tf` to define VM specs, storage, IPs, and SSH configuration.

### 3. Ansible Provisioning

Install Ansible and helper tools:

```bash
sudo apt update && sudo apt install ansible tmux -y
```

Generate and distribute SSH keys:

```bash
ssh-keygen
# Add the public key to Terraform variables for passwordless access
```

Run the playbook:

```bash
ansible-playbook site.yml -i inventory
```

This configures each VM with selected honeypots and prepares Logstash and Wazuh pipelines.

---

## Features

- Modular T-Pot deployment with selective services
- CVE emulation using Vulhub containers
- Centralized log collection using Logstash and Elasticsearch
- Real-time alerts and rule matching via Wazuh

---

## Notes

- This project was developed as a final year capstone in cybersecurity and automation.

---

## Contact

**Author:** [Your Name]  
**Institution:** Polytechnic Institute of Bragança  
**Supervisors:** Professor Tiago Pedrosa, Professor Jeorge Loureiro




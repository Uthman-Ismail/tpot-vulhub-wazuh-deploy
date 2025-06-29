
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

This section outlines the step-by-step process to deploy the automated honeypot environment using Terraform and Ansible.

---

###  Prerequisites

1. **Create a Cloud-Init Template**  
   Use the `cloudinit` configuration file provided to generate a Proxmox template.  

2. **Clone Machines from Template**  
   - Clone **two VMs**: one for Terraform and one for Ansible,  
     OR  
   - Use a **single VM** for both Terraform and Ansible if resources are limited.
   - In the Cloud-Init tab:
	- Set your custom **username** and **password**.

---

###  Terraform Configuration

####  Install Terraform

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform
terraform -install-autocomplete
````

#### Provider and Version

```hcl
source  = "Telmate/proxmox"
version = "3.0.1-rc4"
```

#### Configuration Steps

* Customize `main.tf` to define:

  * VM specs (CPU, RAM, disk)
  * Network interfaces and IPs
  * SSH configuration

* Fill in the `terraform.tfvars` file with your Proxmox credentials and SSH public key.

#### Run Terraform

```bash
terraform plan    # Review the planned infrastructure
terraform apply   # Deploy the machines
```

---

### Ansible Provisioning

#### Install Ansible

```bash
sudo apt update && sudo apt install ansible tmux -y
```

#### SSH Configuration

* Generate an SSH key:

  ```bash
  ssh-keygen
  ```
* Add the public key to the Terraform variable file so the provisioned VMs are accessible by Ansible.

With Terraform, you can create as many machines as needed — all ready to be configured using Ansible.

---

### Ansible Playbook Setup

* Configure the Ansible `inventory` file with the IP addresses of your target machines.

#### Running Playbooks

Example:

```bash
ansible-playbook main.yml -i inventory
```

---

### Playbook Execution Order

1. **Run the `final.yml` playbook first.**

   > *Note: This will change your SSH port.*

2. **Run `vulhub_config.yml`**
   Located inside the `vulhub/` folder, it sets up the Vulhub CVEs.

3. **Run `tpot_logstash.yml`**
   Configures Logstash to collect logs from Vulhub CVEs.

4. **Run `deploy_wazuh.yml`**
   Located in the `tpot/` folder, this deploys and connects Wazuh to the honeypot infrastructure.

---

 The deployment is now complete, with honeypots and Vulhub CVEs monitored through Wazuh.

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


**Author:** Uthman Ismail  
**Institution:** Polytechnic Institute of Bragança  
**Supervisors:** Professor Tiago Pedrosa, Professor Jeorge Loureiro




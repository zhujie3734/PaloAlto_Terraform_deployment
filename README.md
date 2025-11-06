# Terraform Palo Alto vSphere Deployment

Automated deployment of Palo Alto **VM-Series firewalls** on various environment using Terraform.

This module builds and uploads a **bootstrap ISO**, clones a Palo Alto OVA-based template, attaches the bootstrap media, and powers on the firewall with full configuration applied on first boot.

---

## 🚀 Features

- **vSphere automation** — deploy Palo Alto VM-Series from a vCenter template  
- **Bootstrap automation** — dynamically generate `init-cfg.txt` and package it into a valid ISO  
- **Configuration injection** — automatically attach the ISO to the new VM  
- **Multi-NIC support** — easy extension for management / trust / untrust networks  
- **Stateless & reproducible** — rebuild complete environments with one command  

---

## 🧩 Repository Structure

## Future plan
Build images on AWS and Azure

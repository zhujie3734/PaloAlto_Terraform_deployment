🌐 Hybrid Cloud Network Topology
Palo Alto On-Prem Firewall ↔ AWS Transit Gateway (VPN) Deployment Using Terraform

This project demonstrates how to build a hybrid cloud environment by connecting an on-premises Palo Alto firewall to an AWS Transit Gateway using a site-to-site IPSec VPN.
Terraform is used to deploy all AWS cloud components, while the Palo Alto device is manually configured to establish secure connectivity.

🚀 Overview

The goal of this lab is to simulate a real enterprise network architecture:

An on-prem Palo Alto firewall representing a local data center

An AWS VPC hosting internal cloud workloads

An AWS Transit Gateway functioning as the central routing hub

A Site-to-Site VPN providing secure hybrid cloud connectivity

Terraform used as IaC to create all AWS resources

This setup allows you to test BGP, IPSec tunnels, hybrid routing, and cloud–on-prem communication.

🏗️ Architecture Diagram
On-Prem Network (Palo Alto)
   LAN: 192.168.x.x/24
   │
   │  IPSec VPN (IKEv2 + BGP)
   │
Internet
   │
AWS Transit Gateway (TGW)
   │
   ├── TGW VPN Attachment (from PA)
   │
   └── VPC Attachment
           │
           └── Private Subnet
                  └── EC2 Instance (Test VM)

📦 What Terraform Deploys

Terraform provisions the entire cloud side of the hybrid environment:

✔ AWS VPC

Private subnet

Security groups

No Internet Gateway (fully internal)

✔ Transit Gateway (TGW)

TGW route table

VPC attachment

Routing configuration

✔ EC2 Test Instance

Private-only instance

Managed via Session Manager (no public IP required)

✔ IAM Roles for EC2 (SSM access)

The on-prem Palo Alto firewall and the AWS Site-to-Site VPN configuration are performed manually using values from the AWS Console.

🔐 On-Prem Palo Alto Configuration (Manual)

On the physical or virtual Palo Alto firewall:

Configure IKEv2 according to AWS parameters

Create two IPSec tunnels

Assign Tunnel Inside IPs (AWS 169.254.x.x/30 network)

Configure BGP Peering

Local ASN (e.g., 65010)

AWS ASN (64512)

Advertise the internal on-prem LAN

Allow VPN and LAN traffic through security policies

🔄 Hybrid Connectivity Testing

After both sides are configured, validate the connection:

From AWS EC2:
ping <on-prem LAN host>

From On-Prem:
ping <EC2 private IP>

On Palo Alto:
show vpn ike-sa
show vpn ipsec-sa
show routing protocol bgp summary

On AWS:

Check TGW route table

Check VPN tunnel status

Verify learned BGP routes

📁 Repository Structure
├── main.tf          # VPC, Subnet, TGW, EC2 creation
├── variables.tf     # Optional variables
├── outputs.tf       # Useful outputs
└── README.md        # Documentation

✅ Key Achievements

Built a hybrid cloud architecture with AWS and on-prem firewall

Used Terraform to automate cloud networking components

Implemented IPSec VPN with BGP for dynamic routing

Deployed a secure, private-only environment (no public exposure)

Demonstrated modern enterprise multi-cloud connectivity patterns

📚 Technologies Used

Terraform (Infrastructure as Code)

AWS Transit Gateway

AWS VPC + EC2

AWS Site-to-Site VPN

Palo Alto Networks Firewall

BGP Dynamic Routing

AWS Systems Manager Session Manager
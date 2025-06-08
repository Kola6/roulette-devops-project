# 🎲 Roulette Game for Internal Home Users

This is a sample internal-use-only roulette game project designed for deployment inside a secure Azure VNet environment using Kubernetes, Terraform, and Azure DevOps CI/CD.

---

## 🧱 Architecture Overview

```plaintext
                ┌────────────────────────────────────┐
                │       Internal Web Browser         │
                │  http://roulette.internal.company.com │
                └────────────────────────────────────┘
                             │
                             ▼
     ┌────────────────────────────────────────────┐
     │   Azure Private DNS Zone (internal.company.com) │
     │   - A record: roulette → 10.240.0.10              │
     └────────────────────────────────────────────┘
                             │
                             ▼
     ┌────────────────────────────────────────────┐
     │     AKS Cluster + NGINX Ingress Controller  │
     │     - Internal Load Balancer (Private IP)   │
     │     - Whitelist IPs: 10.0.0.0/24, etc.       │
     └────────────────────────────────────────────┘
                             │
                             ▼
     ┌────────────┐         ┌────────────┐
     │ Frontend   │ ←────── │  /         │
     │ React App  │         │ Ingress    │
     └────────────┘         │ Routes     │
     ┌────────────┐ ←────── │  /api      │
     │ Backend API│         └────────────┘
     └────────────┘
```

---

## 🧰 Project Features

- 🔐 Internal-only app using private DNS and IP whitelisting
- ☸️ Deployed to AKS with Ingress Controller
- 🔄 CI/CD via Azure Pipelines
- 🛠️ Infrastructure as Code (Terraform)
- 🐘 PostgreSQL DB with secrets managed via Azure Key Vault

---

## 🚀 Tech Stack

- Frontend: React (Node 18)
- Backend: Node.js + GraphQL
- Infra: Terraform, Azure, AKS, ACR, Key Vault
- DevOps: Azure Pipelines
- Security: Trivy, SonarQube, IP whitelisting

---

## 🗂️ Repository Structure

```
roulette-game/
├── backend/                    # GraphQL backend
├── frontend/                   # React app frontend
├── terraform/                  # Infrastructure as Code
├── k8s/                        # Kubernetes manifests
├── azure-pipelines.yml         # Root CI pipeline
└── .env                        # Environment config
```

---

## 🛡️ Internal Access Only

Only accessible from whitelisted IPs via:
```
http://roulette.internal.company.com
```

Ensure proper DNS linking, internal ILB configuration, and source-range whitelist are in place.

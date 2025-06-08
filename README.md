# 🎲 Roulette Game for Internal Home Users

This is a sample internal-use-only roulette game project designed for deployment inside a secure Azure VNet environment using Kubernetes, Terraform, and Azure DevOps CI/CD.

---

## 🧱 Architecture Overview

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

- 🔐 **Internal-only** app using Azure Private DNS and IP Whitelisting
- ☸️ Deployed to **AKS** with **NGINX Ingress** (internal-only load balancer)
- 🔄 **CI/CD via Azure Pipelines**
- 🛠️ Fully provisioned with **Terraform**
- 🐘 **PostgreSQL DB** with secrets in **Azure Key Vault**
- 🧪 **Security Scanning** with **Trivy** and **SonarQube**

---

## 🚀 Tech Stack

| Layer         | Technology                       |
|---------------|----------------------------------|
| Frontend      | React (Node.js 18)               |
| Backend       | Node.js + GraphQL                |
| Infrastructure| Terraform, AKS, ACR, Key Vault   |
| DevOps        | Azure Pipelines (YAML-based)     |
| Security      | SonarQube, Trivy, Private DNS    |

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

## 🛡️ Private Access Only

### ✅ 1. Deploy NGINX Ingress Controller (Internal)

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx \
  --namespace ingress-basic --create-namespace \
  --set controller.service.annotations."service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"="true"

✅ 2. Get Assigned Internal Load Balancer IP

kubectl get svc ingress-nginx-controller -n ingress-basic

✅ 3. Create Azure Private DNS Zone

az network private-dns zone create \
  --resource-group roulette-dev-rg \
  --name internal.company.com

Link to your VNet:

az network private-dns link vnet create \
  --resource-group roulette-dev-rg \
  --zone-name internal.company.com \
  --name link-to-aks-vnet \
  --virtual-network roulette-vnet \
  --registration-enabled false

✅ 4. Add DNS Record

az network private-dns record-set a add-record \
  --resource-group roulette-dev-rg \
  --zone-name internal.company.com \
  --record-set-name roulette \
  --ipv4-address 10.240.0.10


🛡️ Internal Access Only
The app is only accessible from internal whitelisted IPs:


http://roulette.internal.company.com






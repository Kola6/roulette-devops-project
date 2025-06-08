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

🛠️ Key Features
🔒 Internal-only app using Azure Private DNS + ILB

☸️ Deployed to AKS behind NGINX Ingress (internal)

🔁 Fully automated CI/CD via Azure Pipelines

🛠️ Infrastructure-as-Code with Terraform

🔐 PostgreSQL with random password stored in Key Vault

🧪 Code scanning using Trivy and SonarQube


⚙️ Prerequisites
Azure CLI installed and logged in

Terraform >= 1.3

Helm 3

Kubectl configured with AKS

Azure DevOps project with pipelines enabled

A private VNet + subnet for AKS

---

## 🚀 Tech Stack


| Layer          | Technology                           |
|----------------|---------------------------------------|
| **Frontend**   | React (Node.js 18)                    |
| **Backend**    | Node.js + GraphQL                     |
| **Database**   | PostgreSQL Flexible Server (Azure)    |
| **Secrets**    | Azure Key Vault                       |
| **Infrastructure** | Terraform                        |
| **Platform**   | AKS (Azure Kubernetes Service)        |
| **DevOps**     | Azure Pipelines                       |
| **Registry**   | Azure Container Registry (ACR)        |
| **Ingress**    | NGINX with Internal Load Balancer     |
| **DNS**        | Azure Private DNS Zone                |
| **Security**   | SonarQube, Trivy                      |


---

## 🗂️ Repository Structure

```
roulette-game/
├── backend/                    # GraphQL backend (Node.js)
├── frontend/                   # React frontend
├── k8s/                        # Deployment/Service/Ingress YAMLs
├── terraform/                  # AKS, DB, Key Vault, DNS, ACR
├── .env                        # Local environment variables
└── README.md                   # Project documentation

```

---

## 🛡️ Private Access Only

✅ Configure Ingress (Internal Only)

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx \
  --namespace ingress-basic --create-namespace \
  --set controller.service.annotations."service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"="true"

✅ Get Assigned Internal Load Balancer IP

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






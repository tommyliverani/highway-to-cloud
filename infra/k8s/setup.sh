#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Load configuration
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
    echo "ERROR: ${ENV_FILE} not found"
    echo "Create it from the required configuration variables."
    exit 1
fi

set -a
source "${ENV_FILE}"
set +a

# ============================================================
# Validate configuration
# ============================================================

: "${CLUSTER_NAME:?CLUSTER_NAME is required}"
: "${REPO_URL:?REPO_URL is required}"
: "${REPO_USERNAME:?REPO_USERNAME is required}"
: "${REPO_PAT:?REPO_PAT is required}"
: "${REPO_REVISION:?REPO_REVISION is required}"
: "${REPO_PATH:?REPO_PATH is required}"

ARGOCD_NAMESPACE="argocd"
CROSSPLANE_NAMESPACE="crossplane-system"
INGRESS_NAMESPACE="ingress-nginx"
ARGOCD_HOSTNAME="${ARGOCD_HOSTNAME:-argocd.local}"

# ============================================================
# Check dependencies
# ============================================================

for cmd in kind kubectl helm; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: $cmd is not installed"
        exit 1
    fi
done

# ============================================================
# Create Kind cluster
# ============================================================

echo "==> Creating Kind cluster: ${CLUSTER_NAME}"

if kind get clusters | grep -qx "${CLUSTER_NAME}"; then
    echo "Cluster already exists, skipping creation."
else
    cat <<EOF | kind create cluster --name "${CLUSTER_NAME}" --config -
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
fi

kubectl config use-context "kind-${CLUSTER_NAME}"

# ============================================================
# Install NGINX Ingress Controller (Kind provider)
# ============================================================

echo "==> Installing NGINX Ingress Controller"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait \
    --namespace "${INGRESS_NAMESPACE}" \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=180s

# ============================================================
# Install Argo CD
# ============================================================

echo "==> Installing Argo CD"

kubectl create namespace "${ARGOCD_NAMESPACE}" \
    --dry-run=client -o yaml |
    kubectl apply -f -

kubectl apply \
    --server-side \
    --force-conflicts \
    -n "${ARGOCD_NAMESPACE}" \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait \
    --namespace "${ARGOCD_NAMESPACE}" \
    --for=condition=available \
    --timeout=180s \
    deployment/argocd-server

# ============================================================
# Expose Argo CD via Ingress
# ============================================================

echo "==> Configuring Argo CD Ingress (${ARGOCD_HOSTNAME})"

# Argo CD serves gRPC/TLS by default; switch to plain HTTP so a
# standard nginx Ingress can proxy it without TLS passthrough.
kubectl patch configmap argocd-cmd-params-cm \
    -n "${ARGOCD_NAMESPACE}" \
    --type merge \
    -p '{"data":{"server.insecure":"true"}}'

kubectl rollout restart deployment/argocd-server -n "${ARGOCD_NAMESPACE}"

kubectl wait \
    --namespace "${ARGOCD_NAMESPACE}" \
    --for=condition=available \
    --timeout=180s \
    deployment/argocd-server

kubectl apply -n "${ARGOCD_NAMESPACE}" -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server
  namespace: ${ARGOCD_NAMESPACE}
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: nginx
  rules:
  - host: ${ARGOCD_HOSTNAME}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 80
EOF

# ============================================================
# Install Crossplane
# ============================================================

echo "==> Installing Crossplane"

helm repo add crossplane-stable \
    https://charts.crossplane.io/stable \
    --force-update

helm repo update

helm upgrade --install crossplane \
    crossplane-stable/crossplane \
    --namespace "${CROSSPLANE_NAMESPACE}" \
    --create-namespace \
    --wait \
    --timeout 5m

# ============================================================
# Configure Git repository in Argo CD
# ============================================================

echo "==> Configuring Git repository"

kubectl apply -n "${ARGOCD_NAMESPACE}" -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: demo-git-repo
  namespace: ${ARGOCD_NAMESPACE}
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: ${REPO_URL}
  username: ${REPO_USERNAME}
  password: ${REPO_PAT}
EOF

# ============================================================
# Create Argo CD Application
# ============================================================

echo "==> Creating Argo CD Application"

kubectl apply -n "${ARGOCD_NAMESPACE}" -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo
  namespace: ${ARGOCD_NAMESPACE}
spec:
  project: default

  source:
    repoURL: ${REPO_URL}
    targetRevision: ${REPO_REVISION}
    path: ${REPO_PATH}

  destination:
    server: https://kubernetes.default.svc
    namespace: default

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

# ============================================================
# Status
# ============================================================

echo
echo "============================================================"
echo "Demo environment ready!"
echo "============================================================"

kubectl get nodes

echo
echo "Argo CD:"
kubectl get pods -n "${ARGOCD_NAMESPACE}"

echo
echo "Crossplane:"
kubectl get pods -n "${CROSSPLANE_NAMESPACE}"

echo
echo "Application:"
kubectl get application demo -n "${ARGOCD_NAMESPACE}"

echo
echo "Ingress:"
kubectl get ingress -n "${ARGOCD_NAMESPACE}"

echo
echo "Access Argo CD at:"
echo
echo "  http://${ARGOCD_HOSTNAME}"
echo
echo "If it doesn't resolve, add this line to /etc/hosts:"
echo
echo "  127.0.0.1 ${ARGOCD_HOSTNAME}"


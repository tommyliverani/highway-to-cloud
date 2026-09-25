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

ARGOCD_NAMESPACE="argocd"
CROSSPLANE_NAMESPACE="crossplane-system"
ARGOCD_PORT="${ARGOCD_PORT:-8080}"
REPO_REVISION="${REPO_REVISION:-main}"
ARGO_APP_PATH="resources/argo-apps"

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
    kind create cluster --name "${CLUSTER_NAME}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}"

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
# Create Argo CD Application (resources/argo-app)
# ============================================================

# Syncs the manifests under resources/argo-app from main, the branch that only holds deployed resources.
echo "==> Creating Argo CD Application argo-app (${REPO_REVISION}:${ARGO_APP_PATH})"

kubectl apply -n "${ARGOCD_NAMESPACE}" -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argo-app
  namespace: ${ARGOCD_NAMESPACE}
spec:
  project: default
  source:
    repoURL: ${REPO_URL}
    targetRevision: ${REPO_REVISION}
    path: ${ARGO_APP_PATH}
    # Every manifest under resources/argo-apps, except the files the platform process writes in each
    # resource folder (they are not Kubernetes objects to apply).
    directory:
      recurse: true
      exclude: '{**/metadata.yaml,**/catalog-info.yaml,**/variables.json}'
  destination:
    server: https://kubernetes.default.svc
    namespace: ${ARGOCD_NAMESPACE}
  # No automated sync: changes are applied with a manual Sync from the Argo CD UI.
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
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
kubectl get application argo-app -n "${ARGOCD_NAMESPACE}"


# ============================================================
# Expose Argo CD via port-forward
# ============================================================

ARGOCD_PASSWORD="$(kubectl get secret argocd-initial-admin-secret \
    -n "${ARGOCD_NAMESPACE}" \
    -o jsonpath='{.data.password}' | base64 -d)"

echo
echo "Argo CD:  https://localhost:${ARGOCD_PORT}  (self-signed certificate)"
echo "User:     admin"
echo "Password: ${ARGOCD_PASSWORD}"
echo
echo "Port-forward running, press Ctrl+C to stop."

exec kubectl port-forward svc/argocd-server \
    -n "${ARGOCD_NAMESPACE}" \
    "${ARGOCD_PORT}:443"


#!/usr/bin/env bash
# infra_deployment.sh
# Automated, unified deployment script for HelixScale infrastructure and workloads.
# Suitable for local execution or CI/CD pipelines.

set -e

# Default values
ENV="${1:-dev}"
ACTION="${2:-deploy}"

echo "=========================================================="
echo " HelixScale Unified Deployment Pipeline"
echo " Environment: $ENV"
echo " Action:      $ACTION"
echo "=========================================================="

# Ensure we operate from the repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [ "$ACTION" == "plan" ]; then
    echo "--- [1/3] Running Terraform Plan ---"
    make ENV="$ENV" tf-plan
    echo "Plan complete. Review output above."

elif [ "$ACTION" == "deploy" ]; then
    echo "--- [1/3] Provisioning Infrastructure (Terraform) ---"
    make ENV="$ENV" tf-apply

    echo "--- [2/3] Configuring Compute Nodes (Ansible) ---"
    make ENV="$ENV" ansible-deploy

    echo "--- [3/3] Deploying Kubernetes Workloads (Helm) ---"
    make ENV="$ENV" helm-deploy

    echo "=========================================================="
    echo " Deployment to $ENV complete!"
    echo "=========================================================="

elif [ "$ACTION" == "destroy" ]; then
    echo "WARNING: This will destroy the $ENV environment!"
    read -p "Are you sure? (y/N): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        cd "infra/terraform/environments/$ENV"
        terraform destroy -auto-approve
        echo "Destroy complete."
    else
        echo "Aborted."
    fi
else
    echo "Usage: $0 [ENV] [plan|deploy|destroy]"
    echo "Example: $0 prod deploy"
    exit 1
fi

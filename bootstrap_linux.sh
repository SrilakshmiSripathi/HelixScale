#!/bin/bash

# ------------------------------------------
# bootstrap.sh - Platform Manager
# Purpose: Safely sets up the development environment for HelixScale
# Requirements: Bash 3+, curl, wget
# ------------------------------------------

set -e          # Exit on error
set -o pipefail # Enable pipeline error checking
set -u          # Treat unset variables as errors

echo "=========================================="
echo " 🚀 HelixScale Platform Manager "
echo "📍 Architecture: local Mac M-Series"
echo "=========================================="
echo ""

# --- Configuration Variables ---
PROJECT_NAME="HelixScale"
UV_VERSION=latest
PYTHON_VERSION=latest
TERRAFORM_VERSION=latest
ANSIBLE_VERSION=latest

# --- Step 0: Memory Baseline Check
check_memory_budget() {
    echo "Checking for Available memory"
    # 1. Bypass check if user explicitly forced safety acknowledgment
    echo ""
    echo "--- ⚠️  MEMORY BUDGET CHECK ---"
    echo "🔍 Open 'Activity Monitor' on Host."
    echo "   - Ensure RAM usage > 50% of Total."
    echo "   - Close background apps (Terminal/VSCode heavy processes)."
    echo "   - Verify Lids are OPEN and Power is CONNECTED."
    echo ""

    read -r -n 1 -p "Have you closed apps and checked thermal status? [Y/N]: " MEMORY_SAFE
    if [[ ! "$MEMORY_SAFE" =~ ^[Yy]$ ]]; then
        echo "❌ Aborting. Please adjust RAM usage and thermal status first."
        return 0
    fi
}

detect_os() {
    local HOST_OS=""
    if [[ $(uname) == "Darwin" ]]; then
        HOST_OS="macos-arm64"
    elif [[ $(uname) == "Linux" ]]; then
        HOST_OS="linux-$(uname -m)" # e.g., linux-amd64 or linux-arm64
    else
        echo "❌ Unsupported OS. Exiting."
        exit 1
    fi
    echo "🔍 Detected Host: ${HOST_OS}"
    echo "✅ Acknowledged. Proceeding with installation..."
}


install_mac_tools() {
    echo ""
    echo "--- 🔨 Installing Essential Tools ---"

    # Check for Brew
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please install via https://brew.sh/"
        return 1
    fi
    # Update Brew
    echo "Cleaning up and Updating Homebrew..."
    brew cleanup
    brew update && brew upgrade --greedy

    # List of tools to install
        local tools=("ansible" "helm" "kubernetes-cli" "terraform" "awscli")

        for tool in "${tools[@]}"; do
            if ! command -v "$tool" &> /dev/null; then
                echo "🛠️  Installing $tool..."
                brew uninstall "$tool" || { echo "❌ $tool install failed."; return 1; }
            else
                echo "✅ $tool is already installed."
            fi
        done

    # Verify Caffeinate (Native tool, no install needed)
        if command -v caffeinate &> /dev/null; then
            echo "✅ Caffeinate system utility ready."
        else
            echo "❌ Error: Caffeinate not found. This is unexpected on macOS."
            return 1
        fi

    # --- 1. Verify Kube-config ---
    echo "--- 🔍 Checking Kube-config ---"
    if [ -f "$HOME/.kube/config" ]; then
        echo "✅ Kube-config found at ~/.kube/config"

    else
        echo "❌ Kube-config not found. Ensure K3s is initialized and the config is copied to ~/.kube/config"
        exit 1
    fi

    # --- 2. Verify Cgroup v2 (Run inside worker VMs) ---
    # Note: This is an example command to run via SSH
    echo "--- 🔍 Verifying Cgroup v2 on Workers ---"
    for node in "worker-1" "worker-2"; do
        echo "Checking $node..."
        ssh "$node" "stat -fc %T /sys/fs/cgroup/" | grep -q "cgroup2fs" && echo "✅ $node: Cgroup v2 active" || echo "❌ $node: Cgroup v2 NOT active"
    done

    # --- 3. Deploy NFS CSI Driver via Helm ---
    echo "--- 🚀 Deploying NFS CSI Driver ---"
    helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
    helm repo update
    helm upgrade --install csi-driver-nfs csi-driver-nfs/csi-driver-nfs \
        --namespace kube-system \
        --set controller.replicas=1

    echo "--- ✅ Setup Complete ---"
}

# --- EXECUTE THE FUNCTION ---
check_memory_budget
detect_os
install_mac_tools

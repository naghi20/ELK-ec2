#!/usr/bin/env bash
# Installs a single-node k3s cluster on this EC2 instance, plus Helm.
# Run as: bash install-k3s.sh
set -euo pipefail

echo "Installing k3s..."
curl -sfL https://get.k3s.io | sh -

echo "Waiting for k3s to be ready..."
sudo k3s kubectl wait --for=condition=Ready node --all --timeout=120s

echo "Setting up kubeconfig for the current user (no sudo needed for kubectl)..."
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown "$(id -u)":"$(id -g)" ~/.kube/config
export KUBECONFIG=~/.kube/config
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc

echo "Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
rm -f get_helm.sh

echo "Done. Verify with: kubectl get nodes"

#!/usr/bin/env bash
set -euo pipefail

KCONF="$(dirname "$0")/ai-agent.kubeconfig"
DURATION="${DURATION:-8760h}"

# Ensure the ServiceAccount and ClusterRoleBinding exist (ignore if already present)
kubectl create sa ai-agent -n default 2>/dev/null || true
kubectl create clusterrolebinding ai-agent-view \
    --clusterrole=view \
    --serviceaccount=default:ai-agent 2>/dev/null || true

TOKEN=$(kubectl -n default create token ai-agent --duration="$DURATION")
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA_DATA=$(kubectl config view --raw --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

kubectl config --kubeconfig="$KCONF" set-cluster "$CLUSTER_NAME" --server="$SERVER"
kubectl config --kubeconfig="$KCONF" set clusters."$CLUSTER_NAME".certificate-authority-data "$CA_DATA"

kubectl config --kubeconfig="$KCONF" set-credentials ai-agent \
    --token="$TOKEN"

kubectl config --kubeconfig="$KCONF" set-context ai-agent \
    --cluster="$CLUSTER_NAME" \
    --user=ai-agent \
    --namespace=default

kubectl config --kubeconfig="$KCONF" use-context ai-agent

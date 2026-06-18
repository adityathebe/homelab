terraform-cloudflare:
	cd terraform/cloudflare && terraform apply

terraform-sops-encrypt:
	cd terraform/cloudflare && sops --encrypt --age $$(cat $$SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --unencrypted-regex '^(kind)$$' --in-place ./secret.sops.yaml

terraform-sops-decrypt:
	cd terraform/cloudflare && sops --decrypt --age $$(cat $$SOPS_AGE_KEY_FILE | grep -oP "public key: \K(.*)") --unencrypted-regex '^(kind)$$' --in-place ./secret.sops.yaml

precommit:
	pre-commit install --install-hooks
	pre-commit run --all-files

precommit-update:
	pre-commit autoupdate

# The first step to setup flux on the cluster
bootstrap0:
	kubectl create ns flux-system

	cat $$SOPS_AGE_KEY_FILE | kubectl create secret generic sops-age \
		--namespace=flux-system \
		--from-file=age.agekey=/dev/stdin

# Installs flux
bootstrap:
	flux bootstrap github \
    --private=false \
    --repository=homelab \
    --personal \
    --owner=adityathebe \
    --token-auth \
    --path kubernetes/bootstrap


# Create a kubeconfig for the read-only ai-agent service account (scripts/ai-agent.kubeconfig).
# The ServiceAccount has the built-in "view" ClusterRole attached.
# Override DURATION env var to set token expiry (default: 8760h = 365d).
# Usage:
#   make ai-agent-sa-token
#   env DURATION=24h make ai-agent-sa-token
ai-agent-sa-token:
	bash scripts/ai-agent-sa-token.sh
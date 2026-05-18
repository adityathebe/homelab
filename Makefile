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

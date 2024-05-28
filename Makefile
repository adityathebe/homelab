ansible-portainer:
	cd ansible/main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/portainer.yaml

ansible-portainer-vault:
	cd ansible/main && echo "$$ANSIBLE_VAULT_PASS" | ansible-vault edit --vault-password-file='/bin/cat' host_vars/portainer.yaml

ansible-nodes:
	cd ansible/main && ansible-playbook playbooks/nodes.yaml

ansible-nas-vault:
	cd ansible/truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-vault edit --vault-password-file='/bin/cat' host_vars/truenas.yaml

ansible-nas:
	cd ansible/truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/backup.yaml --ask-become-pass

ansible-nas-node-exporter:
	cd ansible/truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/node-exporter.yaml --ask-become-pass

ansible-vms:
	cd ansible/main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/vms.yaml

ansible-proxmox:
	cd ansible/main && ansible-playbook playbooks/proxmox.yaml

ansible-galaxy:
	cd ansible/main && ansible-galaxy install -r requirements.yaml
	cd ansible/truenas && ansible-galaxy install -r requirements.yaml

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

bootstrap0:
	kubect create ns flux-system

	cat $$SOPS_AGE_KEY_FILE | kubectl create secret generic sops-age \
		--namespace=flux-system \
		--from-file=age.agekey=/dev/stdin

	sops --decrypt kubernetes/bootstrap/vars/cluster-secrets.sops.yaml | \
		kubectl apply --server-side --filename -

bootstrap:
	flux bootstrap github \
		--private=false \
  	--repository=homelab \
  	--personal \
		--owner=adityathebe \
		--token-auth \
  	--path kubernetes/bootstrap

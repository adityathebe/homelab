# Setup k8s workers
workers:
	cd main && ansible-playbook playbooks/workers.yaml

nas-vault:
	cd truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-vault edit --vault-password-file='/bin/cat' host_vars/truenas.yaml

.PHONY: nas
nas:
	cd truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/backup.yaml --ask-become-pass

nas-node-exporter:
	cd truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/node-exporter.yaml --ask-become-pass

ubuntu:
	cd main && ansible-playbook playbooks/ubuntu.yaml

vms:
	cd main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/vms.yaml

node-gpu:
	cd main && ansible-playbook playbooks/node-gpu.yaml

# Example: make cloud-init-template EXTRA_VARS="-e target_host=ramsey"
cloud-init-template:
	cd main && ansible-playbook playbooks/proxmox-cloud-init-template.yaml $(EXTRA_VARS)

galaxy:
	cd main && ansible-galaxy install -r requirements.yaml --force
	cd truenas && ansible-galaxy install -r requirements.yaml --force

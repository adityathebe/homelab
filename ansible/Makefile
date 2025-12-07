media:
	cd main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/media.yaml

# Setup k8s worker nodes
workers:
	cd main && ansible-playbook playbooks/nodes.yaml

nas-vault:
	cd truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-vault edit --vault-password-file='/bin/cat' host_vars/truenas.yaml

.PHONY: nas
nas:
	cd truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/backup.yaml --ask-become-pass

nas-node-exporter:
	cd truenas && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/node-exporter.yaml --ask-become-pass

vms:
	cd main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/vms.yaml

proxmox:
	cd main && ansible-playbook playbooks/proxmox.yaml

node-gpu:
	cd main && ansible-playbook playbooks/node-gpu.yaml

gpu-passthrough:
	cd main && ansible-playbook playbooks/proxmox-gpu-passthrough.yaml

# Example: make cloud-init-template EXTRA_VARS="-e target_host=ramsey"
cloud-init-template:
	cd main && ansible-playbook playbooks/proxmox-cloud-init-template.yaml $(EXTRA_VARS)

galaxy:
	cd main && ansible-galaxy install -r requirements.yaml --force
	cd truenas && ansible-galaxy install -r requirements.yaml --force

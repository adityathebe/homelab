# Setup k8s workers
workers:
	cd main && ansible-playbook playbooks/workers.yaml

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

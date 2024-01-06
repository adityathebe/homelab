ansible-portainer:
	cd ansible/main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/portainer.yaml

ansible-portainer-vault:
	cd ansible/main && echo "$$ANSIBLE_VAULT_PASS" | ansible-vault edit --vault-password-file='/bin/cat' host_vars/portainer.yaml

ansible-nodes:
	cd ansible/main && ansible-playbook playbooks/nodes.yaml

ansible-vms:
	cd ansible/main && echo "$$ANSIBLE_VAULT_PASS" | ansible-playbook --vault-password-file='/bin/cat' playbooks/vms.yaml

ansible-proxmox:
	cd ansible/main && ansible-playbook playbooks/proxmox.yaml

ansible-galaxy:
	cd ansible/main && ansible-galaxy install -r requirements.yaml
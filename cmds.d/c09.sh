# Ansible Galaxy
function galaxy() {
	ECHO "Instala os módulos para o Windows"
	RUN "ansible-galaxy collection install ansible.windows"
	RUN "ansible-galaxy collection install chocolatey.chocolatey"

	ECHO "Instala os roles ajholanda.* usando o Ansible Galaxy"
	RUN "ansible-galaxy role install --force --roles-path ./roles ajholanda.googlechrome"
	RUN "ansible-galaxy role install --force --roles-path ./roles ajholanda.vscode"
}


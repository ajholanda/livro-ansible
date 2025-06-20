function c09() {
	echo "Capítulo 9 - Ansible Galaxy"
	echo "========================================="

	# Ansible Galaxy
	ECHO "Faz download do role ajholanda.x2goclient"
	RUN "ansible-galaxy role install --roles-path ./roles ajholanda.x2goclient"

	ECHO "Instala o cliente X2Go nos hosts pertencentes ao grupo de TI (infotech) "
	RUN "ansible-playbook desktops.yml --tags x2goclient --limit infotech"

	ECHO "Remove o cliente X2Go nos hosts pertencentes ao grupo de TI (infotech) "
	RUN "ansible-playbook desktops.yml --tags x2goclient --limit infotech --extra-vars \"package_state=absent\""

	ECHO "Instala os módulos para o Windows"
	RUN "ansible-galaxy collection install ansible.windows"
	RUN "ansible-galaxy collection install chocolatey.chocolatey"

	ECHO "Instala os roles ajholanda.* usando o Ansible Galaxy (usado nos próximos capítulos)"
	RUN "ansible-galaxy role install --force --roles-path ./roles ajholanda.googlechrome"
	RUN "ansible-galaxy role install --force --roles-path ./roles ajholanda.vscode"
}

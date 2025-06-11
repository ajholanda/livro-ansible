# Desenvolvimento de plugins e módulos
function exec_dev_cmds() {
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

	# Plugins
	## Filtro
	ECHO "Executa e exemplo que mostra o uso do plugin filtro"
	RUN "ansible-playbook plugin.yml"

	## Módulos
	ECHO "Testa o módulo fstab."
	RUN "ansible-playbook test_module.yml"
}

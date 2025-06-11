# Casos de uso
function exec_usecases_cmds() {
	galaxy

	ECHO "Configura servidor(es)"
	RUN "ansible-playbook servers.yml"

	ECHO "Gerenciamento de computadores (desktops)"
	ECHO "Instala os programas nos hosts do grupo desktops"
	RUN "ansible-playbook desktops.yml"
	ECHO "Instala os programas nos hosts do grupo labs"
	RUN "ansible-playbook desktops.yml --limit lab"
	ECHO "Instala o VS Code no host alice"
	RUN "ansible-playbook desktops.yml --limit inf1.example.net --tags vscode"
	ECHO "Remove o Google Chrome do host pedro"
	RUN "ansible-playbook desktops.yml --limit off1.example.net --tags googlechrome --extra-vars 'package_state=absent'"
	ECHO "Atualiza todos os programas do grupo desktops"
	RUN "ansible-playbook desktops.yml --extra-vars 'package_state=latest'"

	ECHO "Força uma atualização no Windows usando o Windows Update (com reboots)"
	RUN "ansible-playbook desktops.yml --tags win_updates"
	ECHO "Atualiza os programas que foram instalados no Windows usando o módulo win_chocolatey do Ansible."
	RUN "ansible-playbook desktops.yml --tags win_chocolatey --limit windows -e 'package_state=latest'"

	# CONTAINER (Docker)
	ECHO "Instala o Docker nos hosts do grupo cloud"
	RUN "ansible-playbook docker.yml --tags docker"
	ECHO "Instala o PHP+Apache no contêiner dos hosts do grupo cloud"
	RUN "ansible-playbook docker.yml --tags docker_php_apache"
	ECHO "Instala o PostgreSQL no contêiner dos hosts do grupo cloud"
	RUN "ansible-playbook docker.yml --tags docker_postgres"
}


function c13() {
	echo "Capítulo 13 - Casos de uso"
	ECHO "========================================="

	setup_galaxy

    # SERVERS
	ECHO "Configura servidor(es)"
	RUN "ansible-playbook servers.yml"

	# DESKTOPS
	ECHO "Instala o Google Chrome em todos os desktops"
	RUN "ansible-playbook desktops.yml --tags googlechrome"
	ECHO "Instala o VS Code nos hosts do grupo labs"
	RUN "ansible-playbook desktops.yml --limit lab --tags vscode"
	ECHO "Instala o VS Code no host ti1"
	RUN "ansible-playbook desktops.yml --limit ti1.example.net --tags vscode"
	ECHO "Remove o Google Chrome do host off1"
	## Inserido como exemplo, pois a máquina virtual a atualização
	## é excessivamente lenta.
	# ECHO "Força uma atualização no Windows usando o Windows Update (com reboots)"
	# RUN "ansible-playbook desktops.yml --tags win_updates"

	# CONTAINERS
    ## Docker
	ECHO "Instala o Docker nos hosts do grupo cloud"
	RUN "ansible-playbook containers.yml --tags docker"
	ECHO "Instala o PHP+Apache no contêiner dos hosts do grupo cloud"
	RUN "ansible-playbook containers.yml --tags docker_php_apache"
	ECHO "Instala o PostgreSQL no contêiner dos hosts do grupo cloud"
	RUN "ansible-playbook containers.yml --tags docker_postgres"

	# CLOUD (AWS)
	make aws
	ECHO "Provisiona uma instância EC2 na AWS"
	RUN "ansible-playbook aws-ec2_provision.yml"
	ECHO "Executa as tarefas do role webserver na instância EC2"
	RUN "ansible-playbook aws-ec2_deploy.yml -i aws-inventory.aws_ec2.yml --private-key ~/.aws/web-dev.pem"
}

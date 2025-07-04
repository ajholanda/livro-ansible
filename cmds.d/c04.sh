# Variáveis
function c04() {
	echo "Capítulo 4 - Variáveis"
	echo "========================================"

	# Special variables and When
	ECHO "Executa o playbook webserver-Debian.yml"
	RUN 'ansible-playbook webserver-Debian.yml'

	ECHO "Executa o playbook webserver-distro.yml"
	RUN 'ansible-playbook webserver-distro.yml'

	# Facts
	ECHO "Lista as variáveis mágicas do sistema no host web.exemplo"
	RUN 'ansible -m setup web.example.net'

	# Playbook variables
	ECHO "Executa o playbook webserver-vars.yml"
	RUN 'ansible-playbook --extra-vars "groupname=webdev" webserver-vars.yml'

	# Host variables
	ECHO "Executa o playbook webserver-host_vars.yml"
	RUN 'ansible-playbook webserver-host_vars.yml'

	ECHO "Executa o playbook all-group_vars.yml"
	RUN 'ansible-playbook all-group_vars.yml'

	# Register
	ECHO "Usa register para armazenar o status de um arquivo (omitido no livro)"
	RUN 'ansible-playbook register.yml'
}

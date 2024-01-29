# Gabarito
function exec_template_cmds() {
	# Gabaritos
	## Filtros
	RUN 'ansible-playbook filters.yml'

	## Controle de fluxo
	ECHO "Copia o arquivo de configuração do ssh modificado nas workstations (for)"
	RUN 'ansible-playbook workstations.yml --tags sshserver'
}



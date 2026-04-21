function c06() {
	setup_galaxy
	ECHO_CHAPTER "6" "Gabarito (template)"

	## Filtros
	ECHO "Executa o playbook filters.yml para demonstrar o uso de filtros (omitido no livro)"
	RUN 'ansible-playbook filters.yml'

	## Controle de fluxo
	ECHO "Copia o arquivo de configuração do ssh modificado nas workstations (for)"
	RUN 'ansible-playbook workstations.yml --tags sshserver'
}

function c06() {
	echo "Capítulo 6 - Gabarito (template)"
	echo "========================================="

	## Filtros
	ECHO "Executa o playbook filters.yml para demonstrar o uso de filtros"
	RUN 'ansible-playbook filters.yml (omitido no livro)'

	## Controle de fluxo
	ECHO "Copia o arquivo de configuração do ssh modificado nas workstations (for)"
	RUN 'ansible-playbook workstations.yml --tags sshserver'
}

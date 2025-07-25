function c07() {
	echo "Capítulo 7 - Criptografia"
	echo "========================================="

	## Criptografia de arquivos
	ECHO "Executa o role rsyncserver usando o --vault-id"
	RUN "ansible-playbook servers.yml --vault-id vault.txt --limit rsyncservers --tags rsyncserver"

	## Criptografia de variáveis
	ECHO "Ajusta senha para um usuário do MariaDB a partir de um vault"
	RUN 'ansible-playbook servers.yml --limit dbservers --tags mariadbserver'
	
	ECHO "Criptografa um arquivo usando o vault ID prod"
	RUN "ansible-vault encrypt --vault-id prod@vault-prod.txt sssd/templates/sssd.conf.j2 --encrypt-vault-id prod 2>/dev/null"
}

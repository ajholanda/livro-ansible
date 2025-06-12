function c08() {
	echo "Capítulo 8 - Desenvolvimento de plugins e módulos"
	echo "========================================="

	# Plugins
	## Filtro
	ECHO "Executa e exemplo que mostra o uso do plugin filtro"
	RUN "ansible-playbook plugin.yml"

	## Módulos
	ECHO "Testa o módulo fstab."
	RUN "ansible-playbook test_module.yml"
}
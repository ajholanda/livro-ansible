function c08() {
	ECHO_CHAPTER "8" "Desenvolvimento de plugins e módulos"

	ECHO_SUB "Plugins - Exemplo de plugin de filtro"
	ECHO "Executa o exemplo que mostra o uso do plugin filtro"
	RUN "ansible-playbook plugin.yml"

	ECHO_SUB "Módulos"
	ECHO "Testa o módulo fstab."
	RUN "ansible-playbook test_module.yml"
}

function c12() {
	echo "Capítulo 12 - Windows"
	echo "========================================="

	setup_galaxy

	# win_chocolatey module
	ECHO "Instala o LibreOffice no sistem Windows"
	RUN "ansible-playbook desktops.yml --tags libreoffice --limit windows"

	# Serve somente como um exemplo de comando, pois não há nenhuma
	# máquina Windows no grupo lab.
	# win_powershell module
	#ECHO "Executa um script PowerShell para agendar desligamento"
	#RUN "ansible-playbook desktops.yml --tags power --limit windows"

	# win_user module
	ECHO "Gerencia usuários no Windows"
	RUN "ansible-playbook  desktops.yml --tags user --limit windows"
}

# Windows
function exec_windows_cmds() {
	galaxy

	# win_chocolatey module
	ECHO "Instala o LibreOffice no sistem Windows"
	RUN "ansible-playbook desktops.yml --tags libreoffice --limit windows"

	# win_powershell module
	ECHO "Executa um script PowerShell para agendar desligamento"
	RUN "ansible-playbook desktops.yml --tags power --limit windows"

	# win_user module
	ECHO "Gerencia usuários no Windows"
	RUN "ansible-playbook  desktops.yml --tags user --limit windows"
}



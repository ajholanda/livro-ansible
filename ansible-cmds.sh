#!/usr/bin/env bash

DEBUG=0

function ECHO {
	echo >&2 "INFO [$1]"
}

function RUN {
	echo $1
	if [ $DEBUG -eq 1 ]; then
		read -p 'Press any key to continue: ' tmp
	fi
	eval $1 && test 1 -eq 1
	sleep 3
}

function galaxy() {
	ECHO "Instala os módulos para o Windows"
	RUN "ansible-galaxy collection install ansible.windows"
	RUN "ansible-galaxy collection install chocolatey.chocolatey"

	ECHO "Instala os roles ajholanda.* usando o Ansible Galaxy"
	RUN "ansible-galaxy role install --force --roles-path ./roles ajholanda.googlechrome"
	RUN "ansible-galaxy role install --force --roles-path ./roles ajholanda.vscode"
}

function exec_adhoc_cmds() {
	ECHO "Executa o ping no host controlado w3.example.net"
	RUN "ansible w3.example.net -i hosts.ini -m ping"

	ECHO "Instala o pacote apache2 usando o módulo package"
	RUN 'ansible web.example.net -i hosts.ini -m package -a "name=apache2 state=present" --become'

	ECHO "Remove o pacote apache2 nos hosts do grupo webservers"
	RUN 'ansible webservers -i hosts.ini -m package -a "name=apache2 state=absent" --become'

	# TODO: find and evaluate this command in the manuscript
	ECHO "+Instala o pacote httpd usando o módulo dnf, ok nas distribuições derivadas da RedHat"
	RUN 'ansible w3.example.net -i hosts.ini -m dnf -a name=httpd --become'

	ECHO "Instalação do pacote apache2 sem a inclusão explícita do arquivo de inventário"
	RUN 'ansible web.example.net -m package -a name=apache2'

	ECHO "Lista de parâmetros do arquivo de configuração do ansible"
	RUN "ansible-config list | cat | head -32"

	ECHO "Instala o programa git nos hosts do grupo lab:"
	RUN 'ansible lab -m package -a name=git'

	ECHO "Copia o arquivo /etc/resolv.conf do controlador para os hosts pertencentes ao grupo lab:"
	RUN 'ansible lab -m copy -a "src=/etc/resolv.conf dest=/etc/"'

	ECHO "Pega o arquivo /var/log/apache2/access.log de web.example.net"
	RUN 'ansible web.example.net -m fetch -a "src=/var/log/apache2/access.log dest=/tmp/"'

	ECHO "Copia o arquivo /etc/passwd do hosts do grupo lab para o controlador"
	RUN 'ansible lab -m fetch -a "src=/etc/passwd dest=/tmp/"'

	ECHO "Executa o comando stat no arquivo w3.example.net:/etc/passwd"
	RUN "ansible w3.example.net -m stat -a \"path=/etc/passwd\""

	ECHO "Cria o diretório /home/nfs, se não existir, nos hosts do grupo lab:"
	RUN 'ansible lab -m file -a "path=/home/nfs state=directory"'

	ECHO "Altera as permissões do arquivo /etc/shadow nos hosts so grupo lab"
	RUN 'ansible lab -m file -a "path=/etc/shadow owner=root group=shadow mode=0640"'

	ECHO "Remove o arquivo /tmp/texput.log de todos os hosts"
	RUN 'ansible devs -m file -a "path=/tmp/texput.log state=absent"'

	ECHO "Lista usauário que autenticaram em todos os hosts"
	RUN 'ansible servers -m shell -a last | head -16'
}

function exec_playbook_cmds() {
	ECHO "Executa o playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml'

	# Tags
	ECHO "Seleciona etiqueta no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --tags webserver_package'

	ECHO "Exclui etiqueta no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --skip-tags webserver_service'

	ECHO "Seleciona várias etiquetas no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --tags "webserver_package,webserver_service"'

	# Tags always, never
	ECHO "Etiqueta never"
	RUN 'ansible-playbook tags.yml'

	ECHO "Ignora etiqueta never"
	RUN 'ansible-playbook tags.yml --skip-tags always'

	ECHO "Seleciona tarefa marcada com never"
	RUN 'ansible-playbook tags.yml --tags never'

	ECHO "Outra forma de selecionar tarefa marcada com never"
	RUN 'ansible-playbook tags.yml --tags debug'

	ECHO "Executa tarefas que tenham pelo menos uma etiqueta"
	RUN 'ansible-playbook tags.yml --tags tagged'

	ECHO "Executa tarefas que não tenham etiquetas"
	RUN 'ansible-playbook tags.yml --tags untagged'

	# Erro
	ECHO "Erro de sintaxe"
	RUN 'ansible-playbook err.yml --tags err1'
}

function exec_vars_cmds() {
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

	# Register
	ECHO "Usa register para armazenar o status de um arquivo"
	RUN 'ansible-playbook register.yml'
}

function exec_roles_cmds() {
	ECHO "Executa o playbook webserver-role.yml (role webserver) somente em web.example.net"
	RUN 'ansible-playbook webserver-role.yml --limit web.example.net'
}

function exec_template_cmds() {
	# Gabaritos
	## Filtros
	RUN 'ansible-playbook filters.yml'

	## Controle de fluxo
	ECHO "Copia o arquivo de configuração do ssh modificado nas workstations (for)"
	RUN 'ansible-playbook workstations.yml --tags sshserver'
}

function exec_crypto_cmds() {
	# Criptografia
	## Criptografia de arquivos
	ECHO "Executa o role rsyncserver usando o --vault-id"
	RUN "ansible-playbook servers.yml --vault-id vault.txt --limit rsyncservers --tags rsyncserver"

	ECHO "Criptografa um arquivo usando o vault ID prod"
	RUN "ansible-vault encrypt --vault-id prod@vault-prod.txt sssd/templates/sssd.conf.j2 --encrypt-vault-id prod 2>/dev/null"

	## Criptografia de variáveis
	ECHO "Ajusta senha para um usuário do MariaDB a partir de um vault"
	RUN 'ansible-playbook servers.yml --limit dbservers --tags mariadbserver'
}

# Ansible Galaxy
function exec_galaxy() {
	ECHO "Faz download do role ajholanda.x2goclient"
	RUN "ansible-galaxy role install --roles-path ./roles ajholanda.x2goclient"

	ECHO "Instala o cliente X2Go nos hosts pertencentes ao grupo de TI (infotech) "
	RUN "ansible-playbook desktops.yml --tags x2goclient --limit infotech"

	ECHO "Remove o cliente X2Go nos hosts pertencentes ao grupo de TI (infotech) "
	RUN "ansible-playbook desktops.yml --tags x2goclient --limit infotech --extra-vars \"package_state=absent\""

	ECHO "Instala os módulos para o Windows"
	RUN "ansible-galaxy collection install ansible.windows"
	RUN "ansible-galaxy collection install chocolatey.chocolatey"
}

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

# Casos de uso
function exec_usecases_cmds() {
	galaxy

	ECHO "Configura servidor(es)"
	RUN "ansible-playbook servers.yml"

	ECHO "Gerenciamento de computadores (desktops)"
	ECHO "Instala os programas nos hosts do grupo desktops"
	RUN "ansible-playbook desktops.yml"
	ECHO "Instala os programas nos hosts do grupo labs"
	RUN "ansible-playbook desktops.yml --limit lab"
	ECHO "Instala o VS Code no host alice"
	RUN "ansible-playbook desktops.yml --limit inf1.example.net --tags vscode"
	ECHO "Remove o Google Chrome do host pedro"
	RUN "ansible-playbook desktops.yml --limit off1.example.net --tags googlechrome --extra-vars 'package_state=absent'"
	ECHO "Atualiza todos os programas do grupo desktops"
	RUN "ansible-playbook desktops.yml --extra-vars 'package_state=latest'"

	ECHO "Força uma atualização no Windows usando o Windows Update (com reboots)"
	RUN "ansible-playbook desktops.yml --tags win_updates"
	ECHO "Atualiza os programas que foram instalados no Windows usando o módulo win_chocolatey do Ansible."
	RUN "ansible-playbook desktops.yml --tags win_chocolatey --limit windows -e 'package_state=latest'"
}

function exec_linux_cmds() {
	exec_adhoc_cmds
	exec_playbook_cmds
	exec_vars_cmds
	exec_roles_cmds
	exec_template_cmds
	exec_crypto_cmds
	exec_usecases_cmds
}

USAGE=$(
	cat <<-EOM
		$0 [--all | -c[2..10] | --galaxy | --linux | --windows] [--debug]
		onde cada opção executa os comandos:
		  --all     todos
		  -c2       do Capítulo 2 - comandos ad-hoc
		  -c3       do Capítulo 3 - playbook
		  -c4       do Capítulo 4 - variáveis
		  -c5       do Capítulo 5 - roles
		  -c6       do Capítulo 6 - gabarito
		  -c7       do Capítulo 7 - criptografia
		  -c8       do Capítulo 8 - Ansible Galaxy
		  -c9       do Capítulo 9 - Windows
		  -c10      do Capítulo 10 - casos de uso
		  --galaxy  de atualização dos roles do Ansible do Ansible Galaxy
		  --linux   para os sistemas Linux
		  --windows para os sistemas Windows
		--debug: pausa a execução a cada comando.
	EOM
)

if [ $2 == "--debug" ]; then
	DEBUG=1
fi

case $1 in
"--all")
	exec_linux_cmds
	;;
"-c2")
	exec_adhoc_cmds
	;;
"-c3")
	exec_playbook_cmds
	;;
"-c4")
	exec_vars_cmds
	;;
"-c5")
	exec_roles_cmds
	;;
"-c6")
	exec_template_cmds
	;;
"-c7")
	exec_crypto_cmds
	;;
"-c8")
	exec_galaxy
	;;
"-c9")
	exec_windows_cmds
	;;
"-c10")
	exec_usecases_cmds
	;;
"--galaxy")
	galaxy
	;;
"--linux")
	exec_linux_cmds
	;;
"--windows")
	exec_windows_cmds
	;;
*)
	echo >&2 "$USAGE"
	exit 1
	;;
esac

ECHO "DONE"
exit 0

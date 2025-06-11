# Comandos específicos (ad-hoc)
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


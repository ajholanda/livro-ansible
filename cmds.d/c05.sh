# Ansible roles
function exec_roles_cmds() {
	ECHO "Executa o playbook webserver-role.yml (role webserver) somente em web.example.net"
	RUN 'ansible-playbook webserver-role.yml --limit web.example.net'
}



# Ansible roles
function exec_roles_cmds() {
	ECHO "Executa o playbook webserver-role.yml (role webserver_debian) somente no host web.example.net"
	RUN 'ansible-playbook webserver-role.yml --tags webserver_debian'
}

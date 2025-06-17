function c05() {
	echo "Capítulo 5 - Ansible roles"
	echo "========================================="

	ECHO "Executa o playbook webserver-role.yml (role webserver_debian) somente no host web.example.net"
	RUN 'ansible-playbook webserver-role.yml --tags webserver_debian'

	ECHO "Executa o playbook webserver-role.yml nos hosts do grupo webservers"
	RUN 'ansible-playbook webserver-role.yml'
}

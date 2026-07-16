function c09() {
	ECHO_CHAPTER "9" "Ansible Galaxy"

	# Ansible Galaxy
	ECHO "Pesquisa pelo role ajholanda.x2goclient no Ansible Galaxy"
	RUN "ansible-galaxy search x2go"

	ECHO "Faz download do role ajholanda.x2goclient"
	RUN "ansible-galaxy role install --roles-path ./roles ajholanda.x2goclient"

	ECHO "Instala o cliente X2Go nos hosts pertencentes ao grupo de TI (ti) "
	RUN "ansible-playbook desktops.yml --tags x2goclient --limit ti"

	ECHO "Remove o cliente X2Go nos hosts pertencentes ao grupo de TI (ti) "
	RUN "ansible-playbook desktops.yml --tags x2goclient --limit ti --extra-vars \"x2goclient_state=absent\""

	ECHO "Instala os módulos para o Windows"
	RUN "ansible-galaxy collection install ansible.windows"
	RUN "ansible-galaxy collection install chocolatey.chocolatey"

	ECHO "Instala as coleções e roles usando requirements.yml"
	RUN "ansible-galaxy install -r requirements.yml --force"

	# Construção de EEs
	echo "No comando a seguir há um problema de permissões"
	echo "com o diretório livro/, sincronizado pelo Vagrant:"
	echo "$ ansible-builder build -t my-ee:1.0"
	echo ""
	echo "Vamos contornar o problema usando o diretório /tmp"
	echo "para gerar a imagem, conforme mostrado nos comandos a seguir:"
	echo "$ ansible-builder create --context /tmp/context"
	echo "$ docker build -f /tmp/context/Dockerfile -t my-ee:1.0 /tmp/context"
	echo ""
	ECHO "Cria a image do Execution Environment definido em execution-environment.yml"
	RUN "ansible-builder create --context /tmp/context"
	RUN "docker build -f /tmp/context/Dockerfile -t my-ee:1.0 /tmp/context"

	ECHO "Executa o playbook utilizando o EE gerado"
	RUN "ansible-navigator run site.yml"
}

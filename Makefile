VENV_DIR = $(HOME)/ansible-venv
BASHRC_FILE = $(HOME)/.bashrc
PIPX := /usr/bin/pipx
VENV_SOURCE_LINE = [ -d "$(VENV_DIR)" ] && source "$(VENV_DIR)/bin/activate"
PIP := $(VENV_DIR)/bin/pip
GALAXY := ansible-galaxy
PLAYBOOK := ansible-playbook
MOLECULE := molecule

TRASH := *~

all: apps aws collections docker packages setup-bashrc

$(VENV_DIR):
	python3 -m venv $@

# 1. O primeiro comando instala o ansible e cria o ambiente virtual.
# 2 O segundo comando injeta as aplicações listadas no amsbiente
# virtual ansible.
# 3. O comand ensurepath configura o caminho das aplicações na
# variável de ambiente PATH.
apps:
	$(PIPX) install --include-deps ansible
	$(PIPX) inject ansible \
			ansible-builder \
			ansible-lint \
			ansible-navigator \
			molecule pylint \
			yamllint
	-$(PIPX) ensurepath

packages: $(VENV_DIR)
	$(PIP) install -r requirements.txt

collections: ansible
	$(GALAXY) collection install -r requirements.yml

docker:
	$(PLAYBOOK) containers.yml --tags docker

/etc/ansible/inventory.py: inventory.py /etc/ansible
	install $^
TRASH += /etc/ansible/inventory.py

/etc/ansible:
	sudo mkdir -p $@ && sudo chown $(USER) $@

aws:
	$(GALAXY) collection install amazon.aws
	$(PIP) install awscli boto3 botocore

awx:
	ansible-playbook awx-setup.yml

# Alvo principal para configurar o virtualenv no .bashrc
setup-bashrc:
	@echo "Verificando se o virtualenv já está configurado no .bashrc..."
	@grep -qF '$(VENV_SOURCE_LINE)' $(BASHRC_FILE) || \
	( \
		echo ""; \
		echo "# Ativa o virtualenv do Ansible se ele existir" >> $(BASHRC_FILE); \
		echo '$(VENV_SOURCE_LINE)' >> $(BASHRC_FILE); \
		echo "Linha adicionada com sucesso. Para aplicar, execute: source ~/.bashrc"; \
	)
	@echo "Configuração do .bashrc verificada."

lint:
	ansible-lint -v -c .ansible-lint.prod.yml

versions:
	sh scripts/print_versions.sh

# Gera o playbook do primeiro exemplo de webserver.yml.
webserver-0.yml: webserver.yml
	head -18 $< | grep -v "tags\|- webserver" > $@
TRASH += webserver-0.yml

include_tasks-0.yml: include_tasks.yml
	head -13 $< > $@
TRASH += include_tasks-0.yml

clean:
	$(RM) $(TRASH)

.PHONY: all apps aws awx collections docker lint packages setup-bashrc versions

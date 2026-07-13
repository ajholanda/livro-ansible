VENV_DIR = $(HOME)/ansible-venv
BINDIR := $(VENV_DIR)/bin
BASHRC_FILE = $(HOME)/.bashrc
VENV_SOURCE_LINE = [ -d "$(VENV_DIR)" ] && source "$(VENV_DIR)/bin/activate"
PIP := $(BINDIR)/pip
GALAXY := $(BINDIR)/ansible-galaxy
PLAYBOOK := $(BINDIR)/ansible-playbook
MOLECULE := $(BINDIR)/molecule

TRASH := *~

all: packages setup-bashrc collections roles \
	docker aws \
	/etc/ansible/inventory.py \
	webservers-3.yml include_tasks-3.yml

$(VENV_DIR):
	python3 -m venv $@

# Instala o ansible, as ferramentas auxiliares e as bibliotecas
# dentro do ambiente virtual (venv) criado pelo alvo $(VENV_DIR).
packages: $(VENV_DIR)
	$(PIP) install -r requirements.txt

collections: packages
	$(GALAXY) collection install -r requirements.yml

roles: packages
	$(GALAXY) role install -r requirements.yml

docker: packages
	$(PLAYBOOK) containers.yml --tags docker

/etc/ansible/inventory.py: inventory.py /etc/ansible
	install $^
TRASH += /etc/ansible/inventory.py

/etc/ansible:
	sudo mkdir -p $@ && sudo chown $(USER) $@

aws: $(VENV_DIR)
	$(GALAXY) collection install amazon.aws
	$(PIP) install awscli boto3 botocore

awx: packages
	$(PLAYBOOK) awx-setup.yml

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

# Imprime os valores resolvidos das variáveis para depuração.
debug:
	@echo "HOME             = $(HOME)"
	@echo "USER             = $(USER)"
	@echo "VENV_DIR         = $(VENV_DIR)"
	@echo "BINDIR           = $(BINDIR)"
	@echo "BASHRC_FILE      = $(BASHRC_FILE)"
	@echo "PIP              = $(PIP)"
	@echo "GALAXY           = $(GALAXY)"
	@echo "PLAYBOOK         = $(PLAYBOOK)"
	@echo "MOLECULE         = $(MOLECULE)"
	@echo "VENV_SOURCE_LINE = $(VENV_SOURCE_LINE)"
	@echo "TRASH            = $(TRASH)"

# Gera o playbook do primeiro exemplo de webserver.yml.
webservers-3.yml: webservers.yml
	head -18 $< | grep -v "tags\|- webservers" > $@
TRASH += webservers-3.yml

# Gera o playbook webserver.yml da Seção 3.1.
webservers-3_1.yml: webservers.yml
	head -18 $< > $@
TRASH += webservers-3_1.yml

include_tasks-3.yml: include_tasks.yml
	head -13 $< > $@
TRASH += include_tasks-3.yml

# Gera o arquivo /etc/ansible/hosts usado na seção 3.3
/etc/ansible/hosts: hosts.ini
	sudo install -m 0600 $< $@

# Gera o arquivo /src/ansible/hosts usado na seção 3.3
/srv/ansible/hosts: hosts.ini
	sudo mkdir -p /srv/ansible
	sudo install -m 0644 $< $@

clean:
	$(RM) $(TRASH)
	sudo $(RM) /etc/ansible/hosts
	sudo $(RM) -r /srv/ansible

.PHONY: all aws awx clean collections debug docker lint packages setup-bashrc versions

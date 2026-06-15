VENV_DIR = $(HOME)/ansible-venv
BINDIR := $(VENV_DIR)/bin
BASHRC_FILE = $(HOME)/.bashrc
VENV_SOURCE_LINE = [ -d "$(VENV_DIR)" ] && source "$(VENV_DIR)/bin/activate"
PIP := $(BINDIR)/pip
GALAXY := $(BINDIR)/ansible-galaxy
PLAYBOOK := $(BINDIR)/ansible-playbook
MOLECULE := $(BINDIR)/molecule

TRASH := *~

all: apps aws collections docker packages setup-bashrc \
	/etc/ansible/inventory.py \
	webserver-3.yml include_tasks-3.yml

$(VENV_DIR):
	python3 -m venv $@

# Instala o ansible e as ferramentas auxiliares dentro do
# ambiente virtual (venv) criado pelo alvo $(VENV_DIR).
apps: $(VENV_DIR)
	$(PIP) install \
			ansible \
			ansible-builder \
			ansible-lint \
			ansible-navigator \
			molecule \
			pylint \
			yamllint

packages: $(VENV_DIR)
	$(PIP) install -r requirements.txt

collections: apps
	$(GALAXY) collection install -r requirements.yml

docker: apps
	$(PLAYBOOK) containers.yml --tags docker

/etc/ansible/inventory.py: inventory.py /etc/ansible
	install $^
TRASH += /etc/ansible/inventory.py

/etc/ansible:
	sudo mkdir -p $@ && sudo chown $(USER) $@

aws: $(VENV_DIR)
	$(GALAXY) collection install amazon.aws
	$(PIP) install awscli boto3 botocore

awx: apps
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

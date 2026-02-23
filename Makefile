VENV_DIR = $(HOME)/ansible-venv
BASHRC_FILE = $(HOME)/.bashrc
VENV_SOURCE_LINE = [ -d "$(VENV_DIR)" ] && source "$(VENV_DIR)/bin/activate"
PIP := $(VENV_DIR)/bin/pip
GALAXY := $(VENV_DIR)/bin/ansible-galaxy
PLAYBOOK := $(VENV_DIR)/bin/ansible-playbook
MOLECULE := $(VENV_DIR)/bin/molecule

TRASH := *~

all: ansible aws collections setup-bashrc molecule

$(VENV_DIR):
	python3 -m venv $@

ansible: $(VENV_DIR)
	$(PIP) install -r requirements.txt

collections: ansible
	$(GALAXY) collection install -r requirements.yml

docker:
	$(PLAYBOOK) containers.yml --tags docker

$(MOLECULE): docker
	$(PIP) install -r requirements.txt

/etc/ansible/inventory.py: inventory.py /etc/ansible
	install $^
TRASH += /etc/ansible/inventory.py

/etc/ansible:
	sudo mkdir -p $@ && sudo chown $(USER) $@

aws:
	$(GALAXY) collection install amazon.aws
	$(PIP) install awscli boto3 botocore

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
	sh scripts/versions.sh

# Gera o playbook do primeiro exemplo de webserver.yml.
webserver-0.yml: webserver.yml
	head -18 $< | grep -v "tags\|- webserver" > $@
TRASH += webserver-0.yml

include_tasks-0.yml: include_tasks.yml
	head -13 $< > $@
TRASH += include_tasks-0.yml

clean:
	$(RM) $(TRASH)

.PHONY: all ansible aws collections docker lint setup-bashrc versions

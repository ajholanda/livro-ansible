ECHO "Asserção para assegurar o uso de criptografia nas senhas."
RUN "ansible-playbook assert.yml --tags crypto"

ECHO "Asserção para testar se a quantidade de memória é suficiente para instalar o Blender."
RUN "ansible-playbook assert.yml --tags blender"

ECHO "Asserções para testar vários requisitos."
RUN "ansible-playbook assert.yml --tags reqts"

ECHO "Instala o Molecule, suas dependências, o driver docker e o Docker"
RUN "ansible-playbook molecule.yml"

ECHO "Cria um ambiente (Docker) de testes Molecule padrão"
RUN "molecule init scenario --driver-name docker"

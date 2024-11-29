ECHO "Asserção para assegurar o uso de criptografia nas senhas."
RUN "ansible-playbook assert.yml --tags crypto"

ECHO "Asserção para testar se a quantidade de memória é suficiente para instalar o Blender."
RUN "ansible-playbook assert.yml --tags blender"


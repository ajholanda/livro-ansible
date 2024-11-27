ECHO "Asserção para assegurar o uso de criptografia nas senhas."
RUN "ansible-playbook assert.yml --tags crypto"

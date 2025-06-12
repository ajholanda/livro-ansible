function c11 {
    echo "Capítulo 11 - Testes"
    echo "========================================="

    ECHO "Asserção para assegurar o uso de criptografia nas senhas"
    RUN "ansible-playbook assert.yml --tags crypto"

    ECHO "Asserção para testar se a quantidade de memória é suficiente para instalar o Blender"
    RUN "ansible-playbook assert.yml --tags blender"

    ECHO "Asserções para testar vários requisitos."
    RUN "ansible-playbook assert.yml --tags reqts"

    ECHO "Instala o Molecule, suas dependências, o driver docker e o Docker"
    RUN "ansible-playbook molecule.yml"

    ECHO "Configura um ambiente (Docker) de testes Molecule padrão"
    RUN "molecule init scenario --driver-name docker"

    ECHO "Cria o cenário office usando o driver padrão"
    RUN "molecule init scenario office"

    ECHO "Cria o ambiente para o cenário padrão"
    RUN "molecule create"

    ECHO "Executa a preparação (prepare.yml)"
    RUN "molecule prepare"

    ECHO "Executa o teste (converge.yml)"
    RUN "molecule converge"

    ECHO "Executa o verificador (verifier)"
    RUN "molecule verify"

    ECHO "Realiza o ciclo de vida completo de teste"
    RUN "molecule test"

    ECHO "Realiza o teste no cenário office"
    RUN  "molecule test -s office"
}
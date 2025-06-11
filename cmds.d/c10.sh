# Testes
function exec_tests() {
    ECHO "Cria o ambiente teste"
    RUN "molecule create"

    ECHO "Conecta no ambiente teste"
    ECHO "molecule login"

    ECHO "Remove o ambiente teste"
    RUN "molecule destroy"
}


function c10() {
    echo "Capítulo 10 - Depuração"
    echo "========================================="

    ECHO "Verifica a sintaxe do arquivo lint_v0.yml."
    RUN "ansible-lint lint_v0.yml"

    ECHO "Verifica a sintaxe do arquivo lint_v1.yml."
    RUN "ansible-lint lint_v1.yml"

    ECHO "Verifica a sintaxe do arquivo lint_v1.yml com o comportamento alterado por lint-config.yml."
    RUN "ansible-lint -c lint-config.yml lint_v1.yml"

    ECHO "Verifica a sintaxe do arquivo lint_v2.yml."
    RUN "ansible-lint lint_v2.yml"

    ECHO "Lista todas as regras do ansible-lint."
    RUN "ansible-lint --list-rules --verbose"

    # Debugger
    ECHO "Executa um comando do Ansible com o depurador habilitado pela variável de ambiente."
    RUN "ANSIBLE_ENABLE_TASK_DEBUGGER=true ansible-playbook err.yml"

    ECHO "Abre um sessão de depuração após a falha no playbook."
    RUN "ansible-playbook debugger.yml"
}


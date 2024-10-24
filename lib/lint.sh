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

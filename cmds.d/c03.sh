# Playbook
function c03() {
	echo "Capítulo 3 - Playbook"
	echo "========================================"

	make webserver-0.yml

	ECHO "Executa o playbook webserver.yml"
	RUN 'ansible-playbook webserver-0.yml'

	ECHO "Lista as tarefas do playbook webserver.yml"
	RUN 'ansible-playbook webserver-0.yml --list-tasks'

	ECHO "Lista os hosts do playbook webserver.yml"
	RUN 'ansible-playbook webserver-0.yml --list-hosts'

	ECHO "Inicia a execução do playbook webserver.yml a partir da segunda tarefa"
	RUN 'ansible-playbook webserver-0.yml --start-at-task "Habilita e inicializa o apache"'

	# Plays
	ECHO "PLAYS"

	ECHO 'Lista os plays do playbook plays.yml'
	RUN 'ansible-playbook plays.yml --list-tasks'

	# Tags
	ECHO "ETIQUETAS (TAGS)"

	ECHO "Seleciona etiqueta no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --tags webserver_package'

	ECHO "Exclui etiqueta no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --skip-tags webserver_service'

	ECHO "Seleciona várias etiquetas no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --tags "webserver_package,webserver_service"'

	# Tags always, never
	ECHO "Etiqueta never"
	RUN 'ansible-playbook tags.yml'

	ECHO "Ignora etiqueta never"
	RUN 'ansible-playbook tags.yml --skip-tags always'

	ECHO "Seleciona tarefa marcada com never"
	RUN 'ansible-playbook tags.yml --tags never'

	ECHO "Outra forma de selecionar tarefa marcada com never"
	RUN 'ansible-playbook tags.yml --tags debug'

	ECHO "Executa tarefas que tenham pelo menos uma etiqueta"
	RUN 'ansible-playbook tags.yml --tags tagged'

	ECHO "Executa tarefas que não tenham etiquetas"
	RUN 'ansible-playbook tags.yml --tags untagged'

	ECHO "Lista as etiquetas disponíveis em tags.yml"
	RUN 'ansible-playbook tags.yml --list-tags'

	ECHO "Lista as tarefas disponíveis em tags.yml"
	RUN 'ansible-playbook tags.yml --list-tasks'

	ECHO "Lista as tarefas disponíveis em tags.yml filtrando por etiquetas"
	RUN 'ansible-playbook tags.yml --list-tasks --tags debug,untagged'

	# Manipuladores (handlers)
	ECHO "HANDLERS"

	ECHO "Exemplo de uso da chave listen para agrupar manipuladores"
	RUN 'ansible-playbook listen.yml'

	# Errors
	ECHO "ERROS"

	RUN 'ansible-playbook err.yml --tags err0'
	RUN 'ansible-playbook err.yml --tags err1'
	RUN 'ansible-playbook err.yml --tags err2'
	RUN 'ansible-playbook err.yml --tags err3'
	RUN 'ansible-playbook err.yml --tags err4'
	RUN 'ansible-playbook err.yml --tags err5'

	ECHO "Verifica o comportamento de any_errors_fatal"
	RUN 'ansible-playbook err.yml --tags err6'

	ECHO "Verifica o comportamento de max_fail_percentage"
	RUN 'ansible-playbook err.yml --tags err7'

	ECHO "Verifica o comportamento de force_handlers"
	RUN 'ansible-playbook err.yml --tags err8'

	# import_tasks
	ECHO "CARREGAMENTO DAS TAREFAS"

	ECHO 'Executa tarefas que usam import_tasks'
	RUN 'ansible-playbook import_tasks.yml'

	# include_tasks
	ECHO 'Executa tarefas que usam include_tasks'
	RUN 'ansible-playbook include_tasks.yml'

	make include_tasks-0.yml
	ECHO 'Limitação de include_tasks para listar tarefas dos arquivos incluídos'
	RUN 'ansible-playbook include_tasks-0.yml --list-tasks'

	ECHO 'Limitação de include_tasks para listar etiquetas dos arquivos incluídos'
	RUN 'ansible-playbook include_tasks-0.yml --list-tags'

	ECHO 'Limitação de include_tasks de começar em tarefa de playbook incluído'
	RUN "ansible-playbook include_tasks-0.yml --start-at-task \"Imprime o número da tarefa\""

	# pre_tasks, post_tasks
	ECHO "FLUXO DE EXECUÇÃO DAS TAREFAS"

	ECHO "Exemplo de pre_tasks e post_tasks"
	RUN "ansible-playbook pre_tasks_post.yml"
}


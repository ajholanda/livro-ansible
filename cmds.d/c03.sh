# Playbook
function c03() {
	ECHO_CHAPTER "3" "Playbook"

	make webserver-0.yml

	ECHO "Executa o playbook webserver.yml"
	RUN 'ansible-playbook webserver-0.yml'

	ECHO "Lista as tarefas do playbook webserver.yml"
	RUN 'ansible-playbook webserver-0.yml --list-tasks'

	ECHO "Lista os hosts do playbook webserver.yml"
	RUN 'ansible-playbook webserver-0.yml --list-hosts'

	ECHO "Inicia a execução do playbook webserver.yml a partir da segunda tarefa"
	RUN 'ansible-playbook webserver-0.yml --start-at-task "Habilita e inicia o apache"'

	# Plays
	ECHO_SUB "PLAYS"

	ECHO 'Lista os plays do playbook plays.yml'
	RUN 'ansible-playbook plays.yml --list-tasks'

	# Tags
	ECHO_SUB "ETIQUETAS (TAGS)"

	ECHO "Seleciona etiqueta no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --tags webserver_package'

	ECHO "Exclui etiqueta no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --skip-tags webserver_service'

	ECHO "Seleciona várias etiquetas no playbook webserver.yml"
	RUN 'ansible-playbook webserver.yml --tags "webserver_package,webserver_service"'

	# Tags always, never
	ECHO "Etiquetas always e never"
	RUN 'ansible-playbook tags.yml'

	ECHO "Ignora etiqueta always"
	RUN 'ansible-playbook tags.yml --skip-tags always'

	ECHO "Seleciona tarefa marcada com never"
	RUN 'ansible-playbook tags.yml --tags never'

	ECHO "Outra forma de selecionar tarefa marcada com never"
	RUN 'ansible-playbook tags.yml --tags debug'

	ECHO "Executa tarefas que tenham pelo menos uma etiqueta"
	RUN 'ansible-playbook tags.yml --tags tagged'

	ECHO "Executa tarefas que não etiquetadas"
	RUN 'ansible-playbook tags.yml --tags untagged'

	ECHO "Lista as etiquetas disponíveis em tags.yml"
	RUN 'ansible-playbook tags.yml --list-tags'

	ECHO "Lista as tarefas disponíveis em tags.yml"
	RUN 'ansible-playbook tags.yml --list-tasks'

	ECHO "Lista as tarefas disponíveis em tags.yml filtrando por etiquetas"
	RUN 'ansible-playbook tags.yml --list-tasks --tags debug,untagged'

	ECHO_SUB "MANIPULADORES (HANDLERS)"

	ECHO "Exemplo de uso da chave listen para agrupar manipuladores"
	RUN 'ansible-playbook listen.yml'

	ECHO_SUB "ERROS"
	ECHO "Força ocorrência de erro"
	RUN 'ansible-playbook err.yml --tags err0'

	ECHO "Tenta listar arquivo que não existe"
	RUN 'ansible-playbook err.yml --tags err1'

	ECHO "Ignora o erro"
	RUN 'ansible-playbook err.yml --tags err2'

	ECHO "Não interpreta false como erro"
	RUN 'ansible-playbook err.yml --tags err3'

	ECHO "Arquivo não deve existir para o playbook ser bem-sucedido"
	RUN 'ansible-playbook err.yml --tags err4'

	ECHO "Ativa any_errors_fatal para o playbook"
	RUN 'ansible-playbook err.yml --tags err5'

	ECHO "Verifica o comportamento de any_errors_fatal"
	RUN 'ansible-playbook err.yml --tags err6'

	ECHO "Verifica o comportamento de max_fail_percentage"
	RUN 'ansible-playbook err.yml --tags err7'

	ECHO "Verifica o comportamento de force_handlers"
	RUN 'ansible-playbook err.yml --tags err8'

	ECHO_SUB "BLOCOS DE TAREFAS"
	run 'ansible-playbook server.yml --tags mariadbserver'
	RUN 'ansible-playbook block.yml'

	ECHO_SUB "CARREGAMENTO DAS TAREFAS"

	ECHO 'Executa tarefas que usam import_tasks'
	RUN 'ansible-playbook import_tasks.yml'

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
	ECHO_SUB "FLUXO DE EXECUÇÃO DAS TAREFAS"

	ECHO "Exemplo de pre_tasks e post_tasks"
	RUN "ansible-playbook pre_tasks_post.yml"
}

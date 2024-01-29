#!/usr/bin/env bash

DEBUG=0

# Load functions from chapters.
for f in {01..12}; do
	. /lib/c${f}.sh
done

# Helper function to print on stderr.
function ECHO {
	echo >&2 "INFO [$1]"
}

# Helper function to execute commands.
function RUN {
	echo $1
	if [ $DEBUG -eq 1 ]; then
		read -p 'Press any key to continue: ' tmp
	fi
	eval $1 && test 1 -eq 1
	sleep 3
}

USAGE=$(
	cat <<-EOM
		$0 [--all | -c{02..12]} ] [--debug]
		onde cada opção executa os comandos:
		  all       todos
		  c02       do Capítulo 2 - comandos ad-hoc
		  c03       do Capítulo 3 - playbook
		  c04       do Capítulo 4 - variáveis
		  c05       do Capítulo 5 - roles
		  c06       do Capítulo 6 - gabarito
		  c07       do Capítulo 7 - criptografia
		  c08       do Capítulo 8 - desenvolvimento de plugins e modulos
		  c09       do Capítulo 9 - Ansible Galaxy
		  c10       do Capítulo 10 - testes
		  c11       do Capítulo 11 - Windows
		  c12       do Capítulo 12 - casos de uso
		--debug: pausa a execução a cada comando.
	EOM
)

if [ $2 == "--debug" ]; then
	DEBUG=1
fi

case $1 in
"c02")
	exec_adhoc_cmds
	;;
"c03")
	exec_playbook_cmds
	;;
"c04")
	exec_vars_cmds
	;;
"c05")
	exec_roles_cmds
	;;
"c06")
	exec_template_cmds
	;;
"c07")
	exec_crypto_cmds
	;;
"c08")
	exec_dev_cmds
	;;
"c09")
	galaxy
	;;
"c10")
	exec_tests
	;;
"c11")
	exec_windows_cmds
	;;
"c12")
	exec_usecases_cmds
	;;
"--galaxy")
	galaxy
	;;
"--linux")
	exec_linux_cmds
	;;
"--windows")
	exec_windows_cmds
	;;
*)
	echo >&2 "$USAGE"
	exit 1
	;;
esac

exit 0

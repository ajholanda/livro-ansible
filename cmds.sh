#!/bin/bash

# Base directory where the script is located.
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Debug forces a pause after each command.
DEBUG=1
# Dry run only print the commands on the screen.
DRY_RUN=0

ROLES_PATH="$BASEDIR/roles"

# Helper function to print on stderr.
function ECHO {
	echo >&2 "INFO [$1]"
}

# Helper functions to execute commands.
function run {
	echo $1
	eval $1 && test 1 -eq 1
}

function RUN {
	echo $1

	if [ $DEBUG -eq 1 ]; then
		read -p 'Press any key to continue: ' tmp
	fi
	if [ $DRY_RUN -eq 1 ]; then
		echo "DRY> no operation executed ooo"
	else
		eval $1 && test 1 -eq 1
	fi
	sleep 2
}

function setup_galaxy {
	echo "Instala coleções do Ansible Galaxy"
	echo "========================================="
	run "ansible-galaxy collection install ansible.windows"
	run "ansible-galaxy collection install chocolatey.chocolatey"
	run "ansible-galaxy collection install community.general"
	run "ansible-galaxy collection install community.windows"
	run "ansible-galaxy role install ajholanda.googlechrome --roles-path $ROLES_PATH"
	run "ansible-galaxy role install ajholanda.vscode --roles-path $ROLES_PATH"
	run "ansible-galaxy role install ajholanda.x2goclient --roles-path $ROLES_PATH"
}

function usage {
USAGE=$(
		cat <<-EOM
		$0 [c{00..12]}] [--dry-run | --no-debug | --help]
		  onde:
		    c00       	Executa os comandos de todos os capítulos.
		    c01	    	Capítulo 1 - Automação e Ansible (sem comandos)
		    c02       	Capítulo 2 - Comandos ad-hoc
		    c03       	Capítulo 3 - Playbook
		    c04       	Capítulo 4 - Variáveis
		    c05       	Capítulo 5 - Ansible roles
		    c06       	Capítulo 6 - Gabarito
		    c07       	Capítulo 7 - Criptografia
		    c08       	Capítulo 8 - Desenvolvimento de plugins e modulos
		    c09       	Capítulo 9 - Ansible Galaxy
		    c10       	Capítulo 9 - Depuração
		    c11       	Capítulo 11 - Testes
		    c12       	Capítulo 12 - Windows
		    c13       	Capítulo 13 - Casos de uso
		    --no-debug:	Executa os comandos sem pausas.
		    --dry-run: 	Lista os comandos sem executá-los.
		    --help:	Imprime esta mensagem.

		Exemplos:
		$0 c02 c04 --no-debug --dry-run
		  Lista os comandos dos capítulos 2 e 4 sem pausas.
		$0 c03 c04 c05
		  Executa os comandos dos capítulos 3, 4 e 5 com pausa entre as execuções.
		$0 c00
		  Executa todos os comandos com pausa entre as execuções.
	EOM
)
	echo >&2 "$USAGE"
}

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

# Handle arguments.
chapts=()
for arg in "$@"; do
	if [ -e "$BASEDIR/cmds.d/${arg}.sh" ]; then
		chapts+=${arg}
		shift
	elif [ $arg == "--no-debug" ]; then
		DEBUG=0
		shift
	elif [ $arg == "--dry-run" ]; then
		DRY_RUN=1
		shift
	elif [ $arg == "--help" ]; then
		usage
		exit 1
	fi
done

# After all the shifts, the number of arguments must be zero.
if [ $# -gt 0 ]; then
	usage
	exit 1
fi

# Load all the functions that execute commands from book chapters.
for file in `ls -r $BASEDIR/cmds.d`; do
       source $BASEDIR/cmds.d/${file}
done

# Execute commands from each chapter passed as argument.
for chapt in "${chapts[@]}"; do
	eval $chapt
done

exit 0

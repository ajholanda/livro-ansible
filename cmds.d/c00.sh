function c00 {
	echo "=========================================="
	echo "* Executando todos os comandos."
	echo "=========================================="
	curr_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	for path in `ls ${curr_dir}/*.sh | grep -v c00`; do
       		$(basename $path .sh)
	done
}

function c01 {
	echo "Capítulo 1. Automação e Ansible"
	echo "========================================="
	echo "Seja bem-vindo(a) ao curso de Ansible!"

	make /etc/ansible/inventory.py

	cd /tmp
	ECHO "Lista os hosts de um inventário dinâmico"
	RUN "ansible-inventory -i /etc/ansible/inventory.py --list"

	ECHO "Lista os hosts de um inventário dinâmico de forma hieráquica"
	RUN "ansible-inventory -i /etc/ansible/inventory.py --graph"

	cd $HOME/livro
}

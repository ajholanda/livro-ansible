#!/bin/bash

# Generate a hash using SHA512 algorithm.

if [ $# -ne 1 ]; then
	echo "Error!"
	echo "Usage: $0 <password>"
	exit 1
fi

ansible localhost -m debug -a "msg={{ '$1' | password_hash('sha512') }}"

exit 0

banner() {
	echo "\n== $@ =="
}

colver() {
	ansible-galaxy collection list "$@" | grep "$@"
}

pipver() {
    python -m pip show "$@" |
        awk '/^Name:/ {name=$2} /^Version:/ {print name, $2}'
}

banner ANSIBLE
python --version
pipver ansible-core ansible-lint
colver ansible.posix
colver community.general
colver ansible.mariadb

banner AWS
pipver awscli boto3 botocore
colver amazon.aws

banner DOCKER
docker --version | sed 's/,//' | awk '{print $1" "$3}'
colver community.docker

banner EE
pipver ansible-builder ansible-navigator

banner MOLECULE
pipver molecule molecule-plugins pytest-testinfra

banner WINDOWS
colver ansible.windows
colver chocolatey.chocolatey
colver community.windows

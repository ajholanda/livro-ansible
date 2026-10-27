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
ansible --version | head -1 | sed 's/\[\|\]//g'
ansible-lint --version | awk '{print $1" "$2}'
yamllint --version
colver ansible.posix
colver community.general
colver community.mysql

banner AWS
pipver awscli boto3 botocore
colver amazon.aws

banner EEs
pipver ansible-builder ansible-navigator

banner DOCKER
docker --version | sed 's/,//' | awk '{print $1" "$3}'
colver community.docker

banner MOLECULE
pipver molecule molecule-plugins pytest-testinfra

banner WINDOWS
colver ansible.windows
colver chocolatey.chocolatey
colver community.windows

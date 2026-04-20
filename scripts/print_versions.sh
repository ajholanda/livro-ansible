VERSION=$(pip show ansible | grep "^Version" | awk '{print $2}')
echo "Ansible ${VERSION}"
ansible --version | head -1 | sed 's/\[\|\]//g'
ansible-lint --version | awk '{print $1" "$2}'
docker --version
molecule --version | head -1 | awk '{print $1" "$2}'
python --version

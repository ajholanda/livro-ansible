
apt_pkgs="python3-pip sshpass tree"
echo "APT: Installing ${apt_pkgs}..."
DEBIAN_FRONTEND=noninteractive apt-get install -y ${apt_pkgs} >/dev/null

py_pkgs="ansible ansible-lint yamllint"
echo "PIP: Installing ${py_pkgs}..."
pip install $py_pkgs

echo "DONE"

exit 0

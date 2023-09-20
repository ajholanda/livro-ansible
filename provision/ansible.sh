
pkgs=(ansible ansible-lint python3-pip sshpass yamllint)
for pkg in "${pkgs[@]}"
do
    echo "APT: Installing ${pkg}..."
    apt-get install -y ${pkg} >/dev/null
done

echo "PIP: Installing molecule..."
sudo -u vagrant pip install molecule >/dev/null

echo "DONE"

exit 0


pkgs=(ansible pipx python3-pip sshpass)
for pkg in "${pkgs[@]}"
do
    echo "APT: Installing ${pkg}..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${pkg} >/dev/null
done

pkgs=(ansible-lint molecule yamllint)
for pkg in "${pkgs[@]}"
do
	echo "PIPx: Installing ${pkg}..."
	sudo -u vagrant pipx install ${pkg} >/dev/null
done

# Add programs installed by pipx in the PATH.
sudo -u vagrant pipx ensurepath

echo "DONE"

exit 0


pkgs=(ansible ansible-lint python3-pip sshpass tree yamllint)
for pkg in "${pkgs[@]}"
do
    echo "APT: Installing ${pkg}..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${pkg} >/dev/null
done

echo "DONE"

exit 0
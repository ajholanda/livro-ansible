# Define system packages and Python packages.
apt_pkgs="ansible make python3-pip sshpass tree virtualenv yamllint"
py_pkgs="ansible-lint"

# ---
# Section 1: Install system packages.
# ---
echo "APT: Installing ${apt_pkgs}..."
DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${apt_pkgs} >/dev/null

# ---
# Section 2: Install Python packages.
# ---
echo "PIP: Installing ${py_pkgs}..."
pip install $py_pkgs

echo "DONE"

exit 0

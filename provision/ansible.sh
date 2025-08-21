# Define system packages and Python packages.
apt_pkgs="make python3-pip python3-venv sshpass tree virtualenv"

# ---
# Section 1: Install system packages.
# ---
echo "APT: Installing ${apt_pkgs}..."
DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${apt_pkgs} >/dev/null

echo "DONE"

exit 0

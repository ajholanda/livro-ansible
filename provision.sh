VAGRANT_HOME="/home/vagrant"

# PACKAGE
# Update package sources list
which apt-get >/dev/null && \
    echo 'APT: Updating the list of packages...'; apt-get update >/dev/null
# Install ansible on the controller
if [ "$(hostname)" == "ansible" ]; then
    echo "APT: Installing ansible..."
    apt-get install -y ansible >/dev/null
fi

# SSH
# Create ssh directory for vagrant user
mkdir -p $VAGRANT_HOME/.ssh
# Copy ssh keys
cp /vagrant/provision/id_ed25519* $VAGRANT_HOME/.ssh
# Fix the permissions of the keys files
chmod 400 $VAGRANT_HOME/.ssh/id_ed25519*
# Write the public key to authorized keys list
cp /vagrant/provision/id_ed25519.pub $VAGRANT_HOME/.ssh/authorized_keys
# Copy the ssh client configuration for user vagrant
cp /vagrant/provision/ssh_config $VAGRANT_HOME/.ssh/config
# Fix the permission of the ssh client configuration
chmod 400 $VAGRANT_HOME/.ssh/config
# Fix the owner of ssh directory for vagrant user
chown -R vagrant:vagrant $VAGRANT_HOME/.ssh/

# Allow password authentication via SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd



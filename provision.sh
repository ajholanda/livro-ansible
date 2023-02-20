VAGRANT_HOME="/home/vagrant"
mkdir -p $VAGRANT_HOME/.ssh
cp /vagrant/provision/id_ed25519* $VAGRANT_HOME/.ssh
cp /vagrant/provision/id_ed25519.pub $VAGRANT_HOME/.ssh/authorized_keys
chmod 400 $VAGRANT_HOME/.ssh/id_ed25519*
cp /vagrant/provision/ssh_config $VAGRANT_HOME/.ssh/config
chmod 400 $VAGRANT_HOME/.ssh/config
chown -R vagrant:vagrant $VAGRANT_HOME/.ssh/
# Update package sources list
which apt && apt update
# Allow password authentication via SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd



VAGRANT_HOME="/home/vagrant"
mkdir -p $VAGRANT_HOME/.ssh
cp /vagrant/provision/id_ed25519* $VAGRANT_HOME/.ssh
cp /vagrant/provision/id_ed25519.pub $VAGRANT_HOME/.ssh/authorized_keys
cp /vagrant/provision/hosts /etc/hosts
chmod 400 $VAGRANT_HOME/.ssh/id_ed25519*
chown -R vagrant $VAGRANT_HOME/.ssh/


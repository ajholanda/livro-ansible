VAGRANT_HOME="/home/vagrant"

# PACKAGEs

## Update package sources list on Debian OS Family
which apt-get &>/dev/null \
      && echo 'APT: Updating the list of packages...' \
      && DEBIAN_FRONTEND=noninteractive apt-get update \
      && apt-get -y install build-essentials dkms zstd

## Install wget and the Vagrant dependencies on Red Hat OS Family
which dnf &>/dev/null \
    && echo 'DNF: Installing wget and Vagrant dependencies...'; \
    dnf install -y wget kernel-devel kernel-headers gcc \
                  make perl elfutils-libelf-devel

# SSH
## Create ssh directory for vagrant user
install -o vagrant -g vagrant  -m 700 -d $VAGRANT_HOME/.ssh

## Suppress banner during ssh login
touch $VAGRANT_HOME/.hushlogin

## Download ssh keys
# Keys are copied to all hosts. This allows connections from any hosts.
# Not only the controller. Sometimes we need to copy file from one controlled
# host to another.
echo "SSH: Downloading Vagrant insecure key pair..."
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
      -O $VAGRANT_HOME/.ssh/id_rsa.pub >/dev/null
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant \
      -O $VAGRANT_HOME/.ssh/id_rsa >/dev/null
chmod 400 $VAGRANT_HOME/.ssh/id_rsa

# Authorized key
echo "SSH: Downloading the Vagrant public key as authorized host..."
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
      -O $VAGRANT_HOME/.ssh/authorized_keys >/dev/null
chmod 400 $VAGRANT_HOME/.ssh/authorized_keys

## Write the ssh client configuration for user vagrant
echo "Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    PasswordAuthentication yes
    LogLevel FATAL" > $VAGRANT_HOME/.ssh/config
chmod 644 $VAGRANT_HOME/.ssh/config
## Change the ssh directory owner recursively
chown -R vagrant:vagrant $VAGRANT_HOME/.ssh

## Allow password authentication via SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

FROM local/almalinux-systemd

# Used to inform systemd about docker container
ENV container docker

# Install OpenSSh client/server
RUN yum -y update 
RUN yum -y install openssh-server openssh-clients; yum clean all

# Created because public key is required when starting sshd
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

# Enable root login over ssh
RUN sed -Ei 's,#PermitRootLogin prohibit-password,PermitRootLogin yes,' /etc/ssh/sshd_config
# Allow empty password for root
RUN sed -ri 's,^#PermitEmptyPasswords no,PermitEmptyPasswords yes,' /etc/ssh/sshd_config

# Set the easiest password for root
RUN echo "root:" | chpasswd -e

EXPOSE 22

# Fix sshd error due non-existent /run/sshd
RUN mkdir /run/sshd

# RUN systemctl enable sshd && systemctl start sshd

# Start sshd
#CMD ["/usr/sbin/sshd", "-D", "-e"]

CMD ["/usr/sbin/init"]
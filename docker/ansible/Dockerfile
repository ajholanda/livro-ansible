FROM debian:latest

ENV ANSIBLE_HOST_KEY_CHECKING False
RUN apt update && \
        apt install -y --no-install-recommends ansible openssh-server

# Remove no-needed packages
RUN apt -y autoremove && apt -y autoclean && apt -y clean

# Ensure that root directory permission conforms with ansible constraints
RUN chmod 755 /root

# Set bash as shell for root
RUN usermod -s /bin/bash root

# Fix sshd error due non-existent /run/sshd
RUN mkdir /run/sshd

EXPOSE 22

# Start sshd
CMD ["/usr/sbin/sshd", "-D", "-e"]
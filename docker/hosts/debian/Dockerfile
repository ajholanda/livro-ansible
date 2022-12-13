FROM debian:latest

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
                openssh-server cron python3 python3-apt apt-utils && \
        apt-get clean all

# Enable root login over ssh
RUN sed -Ei 's,#PermitRootLogin prohibit-password,PermitRootLogin yes,' /etc/ssh/sshd_config
# Allow empty password for root
RUN sed -ri 's,^#PermitEmptyPasswords no,PermitEmptyPasswords yes,' /etc/ssh/sshd_config

# Set the easiest password for root
RUN echo "root:" | chpasswd -e

EXPOSE 22

# Fix sshd error due non-existent /run/sshd
RUN mkdir /run/sshd

# Start sshd
CMD ["/usr/sbin/sshd", "-D", "-e"]
FROM almalinux:8.8
LABEL maintainer="NodeSpace Technologies"

ENV container docker

# Update packages to the latest version
RUN dnf -y update \
&& dnf -y autoremove \
&& dnf clean all

# Configure systemd.
# See https://hub.docker.com/_/centos/ for details.
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install required packages.
# Remove packages that are nolonger requried.
# Clean the dnf cache.
RUN dnf -y install \
epel-release \
initscripts \
&& dnf -y update \
&& dnf -y install \
python39 \
python3-pip \
gcc \
sudo \
git \
&& dnf -y autoremove \
&& dnf clean all \
&& rm -rf /var/cache/dnf/*

# Set the default python version.
RUN alternatives --set python3 /usr/bin/python3.9

# Upgrade pip.
RUN pip3 install --upgrade pip

# Install ansible.
RUN pip3 install ansible ansible-lint

# Upgrade ansible and ansible-lint.
RUN pip3 install --upgrade ansible ansible-lint

# Upgrade the system agian - I don't think this is needed, but it doesn't hurt anything.
RUN dnf -y update 

# Create ansible directory and copy ansible inventory file.
RUN mkdir /etc/ansible
COPY hosts /etc/ansible/hosts

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/lib/systemd/systemd"]
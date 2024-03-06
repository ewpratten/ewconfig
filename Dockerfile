FROM fedora:39

# Init DNF
RUN echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf
RUN dnf -y update

# Core system utils
RUN dnf install -y procps-ng 

# Install basic packages
RUN dnf install -y git zsh neovim htop wget curl

# Python
RUN dnf install -y python3 python3-pip

# Networking tools
RUN dnf install -y iproute iputils bind-utils
RUN dnf install -y tcpdump mtr netcat

# Copy this repo into the container
COPY . /tmp/ewconfig
RUN mkdir -p /root/.config && git clone /tmp/ewconfig /root/.config/ewconfig

# Clean up leftover files
RUN rm -rf /root/anaconda-post-nochroot.log /root/anaconda-post.log /root/original-ks.cfg
RUN rm -rf /tmp/ewconfig

# Run the install script
RUN cd /root/.config/ewconfig && echo "y" | sh ./install-linux.sh

# Trust my SSH keys
RUN curl -L https://ewpratten.com/keys?hosts > /root/.ssh/authorized_keys

# Entry point
WORKDIR /root
CMD ["/bin/zsh",  "--login"]

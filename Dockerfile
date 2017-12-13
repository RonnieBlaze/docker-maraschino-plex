FROM phusion/baseimage:0.9.16
MAINTAINER ceyounger <ceyounger@gmail.com>

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match Synology DiskStation's settings
# RUN \
# usermod -u 99 nobody && \
# usermod -g 99 nobody && \
# usermod -d /home nobody && \
# chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install Maraschino for Plex
RUN \
  add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
  add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
  apt-get update -q && \
  apt-get install -qy python unrar unzip wget && \
  mkdir /opt/maraschino && \
  wget -P /tmp/ https://github.com/gugahoi/maraschino/archive/master.zip && \
  unzip /tmp/master.zip -d /opt/maraschino && \
  mv /opt/maraschino/maraschino-master/* /opt/maraschino && \
  rm -rf /opt/maraschino/maraschino-master && \
  rm /tmp/master.zip

#set config directory
VOLUME /config

#expose ports
EXPOSE 7000

# Add plex.sh to execute during container startup
RUN mkdir -p /etc/my_init.d
ADD plex.sh /etc/my_init.d/plex.sh
RUN chmod +x /etc/my_init.d/plex.sh

# Add nzbdrone.sh to execute during container startup
RUN mkdir -p /etc/my_init.d
ADD nzbdrone.sh /etc/my_init.d/nzbdrone.sh
RUN chmod +x /etc/my_init.d/nzbdrone.sh

# Add maraschino to runit
RUN mkdir /etc/service/maraschino
ADD maraschino.sh /etc/service/maraschino/run
RUN chmod +x /etc/service/maraschino/run

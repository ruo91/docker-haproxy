#
# Dockerfile - HAProxy
#
# - Build
# docker build --rm -t haproxy:latest .
#
# - Run
# docker run -d --name="haproxy" -h "haproxy" -p 8080:80 haproxy:latest

# Use the base images
FROM ubuntu:14.04
MAINTAINER Yongbok Kim <ruo91@yongbok.net>

# Change the repository
RUN sed -i 's/archive.ubuntu.com/kr.archive.ubuntu.com/g' /etc/apt/sources.list

# The last update and install package for docker
RUN apt-get update && apt-get install -y supervisor git-core curl build-essential libpcre3-dev

# Variable
ENV SRC_DIR /opt
WORKDIR $SRC_DIR
ENV PROFILE_FILE /etc/profile

# HAProxy
ENV HA_HOME $SRC_DIR/haproxy
ENV PATH $PATH:$HA_HOME/sbin
RUN git clone https://github.com/ruo91/haproxy.git haproxy-source \
 && cd haproxy-source \
 && sed -i "/^PREFIX =/ s:.*:PREFIX = "$HA_HOME":" Makefile \
 && make TARGET=custom CPU=native USE_PCRE=1 USE_LIBCRYPT=1 USE_LINUX_SPLICE=1 USE_LINUX_TPROXY=1 \
 && make install && cd $SRC_DIR && rm -rf haproxy-source \
 && echo '# HAProxy' >> /etc/profile \
 && echo "export HA_HOME=$HA_HOME" >> $PROFILE_FILE \
 && echo 'export PATH=$PATH:$HA_HOME/sbin' >> $PROFILE_FILE

# Add the haproxy scripts
ADD conf/haproxy.cfg $HA_HOME/conf/haproxy.cfg

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Daemon
CMD ["/usr/bin/supervisord"]
FROM ubuntu:precise
MAINTAINER nathan@hurel.me

# Installs base package
RUN apt-get update && apt-get install -y curl build-essential libxml2-dev libxslt-dev git autoconf tar python-setuptools gcc make gettext

COPY s6 /tmp/s6
WORKDIR /tmp/s6
#Need to install make >=4.0
RUN tar -xvzf make-4.1.tar.gz
WORKDIR /tmp/s6/make-4.1
RUN ./configure && make && make install
#Install s6 required packages
WORKDIR /tmp/s6
RUN tar -xvzf skalibs-2.3.1.2.tar.gz
WORKDIR skalibs-2.3.1.2
RUN ./configure && make && make install
WORKDIR /tmp/s6
RUN tar -xvzf execline-2.1.1.0.tar.gz
WORKDIR execline-2.1.1.0
RUN ./configure && make && make install
#Install s6 binary
WORKDIR /tmp/s6
RUN tar -xvzf s6-2.1.2.0.tar.gz
WORKDIR s6-2.1.2.0
RUN ./configure && make && make install

#Copy s6 shutdown script
COPY s6-finish /usr/bin/
RUN chmod a+x /usr/bin/s6-finish

ENTRYPOINT ["/bin/s6-svscan", "-t", "0","/etc/s6"]

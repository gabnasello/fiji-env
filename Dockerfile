FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM debian:buster

# Configure environment
ENV DOCKER_IMAGE_NAME='fiji-env'
ENV VERSION='2023-01-26' 

# Docker name to shell prompt
ENV PS1A="[docker] \[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"
RUN echo 'PS1=$PS1A' >> ~/.bashrc

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openbox tigervnc-standalone-server supervisor gosu && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends lxterminal nano vim wget openssh-client rsync ca-certificates xdg-utils htop tar xzip gzip bzip2 zip unzip && \
    rm -rf /var/lib/apt/lists

# Install Fiji.

# From OpenJDK Java 7 JRE Dockerfile
# http://dockerfile.github.io/#/java
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/openjdk-7-jre
RUN \
  apt-get update && \
  apt-get install -y openjdk-11-jdk && \
  rm -rf /var/lib/apt/lists/*
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Latest version the day this Docker Image has been built
# Fiji version: Imagej 1.53t
# Regular instructions for installing imagej [https://www.scivision.dev/install-imagej-linux/]
WORKDIR /imagej
RUN wget https://downloads.imagej.net/fiji/latest/fiji-linux64.zip && \
    unzip fiji*.zip -d . && \
    rm fiji*.zip

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY menu.xml /etc/xdg/openbox/
COPY supervisord.conf /etc/
EXPOSE 8080

RUN groupadd --gid 1000 app && \
    useradd --home-dir /data --shell /bin/bash --uid 1000 --gid 1000 app && \
    mkdir -p /data
VOLUME /data

ADD scripts/message.sh /
RUN echo "bash /message.sh" >> ~/.bashrc

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec gosu app supervisord"]

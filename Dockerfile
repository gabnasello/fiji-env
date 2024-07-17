FROM lscr.io/linuxserver/webtop:amd64-ubuntu-kde-version-b7c41cf2

# Configure environment
ENV DOCKER_IMAGE_NAME='fiji-env'
ENV VERSION='2024-07-16.1' 

# ports and volumes
EXPOSE 3000

VOLUME /config

# title
ENV TITLE=Fiji

RUN apt-get update && \
    apt-get install -y wget vim git unzip \ 
                       python-is-python3 \
                       python3-pip && \
    apt install -y python-is-python3 maven

# install python resources + graphical libraries used by qt and vispy
RUN apt-get update && \
    apt-get install -qqy  \
        build-essential \
        mesa-utils \
        libgl1-mesa-glx \
        libglib2.0-0 \
        libfontconfig1 \
        libxrender1 \
        libdbus-1-3 \
        libxkbcommon-x11-0 \
        libxi6 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-randr0 \
        libxcb-render-util0 \
        libxcb-xinerama0 \
        libxcb-xinput0 \
        libxcb-xfixes0 \
        libxcb-shape0 \
        && apt-get clean
    
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
RUN wget https://downloads.imagej.net/fiji/latest/fiji-linux64.zip && \
    unzip fiji*.zip -d . && \
    rm fiji*.zip

RUN chmod 777 -R /Fiji.app

# Install Python packages
ADD requirements.txt /
RUN pip install -r /requirements.txt

COPY /desktop/fiji.desktop /usr/share/applications/
COPY /desktop/fiji.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/fiji.desktop

#COPY /desktop/jupyter.desktop /usr/share/applications/
COPY /desktop/jupyter.desktop /config/Desktop/
#RUN cp /usr/local/share/applications/jupyterlab.desktop /config/Desktop/jupyterlab.desktop
RUN chmod 777 /config/Desktop/jupyter.desktop

COPY /desktop/home_dir.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/home_dir.desktop

# Copy examples directory
COPY --chown=abc:abc examples_fiji/ /config/examples_fiji
RUN chmod 777 -R /config/examples_fiji
FROM python:3.8-slim
LABEL maintainer "Mahmoud Eltohamy <mahmoud.mohammed.elhady@gmail.com>"
ENV DEBIAN_FRONTEND=noninteractive

#=============
# Set WORKDIR
#=============
WORKDIR /root

#==================
# General Packages
#------------------
# openjdk-8-jdk
#   Java
# ca-certificates
#   SSL client
# tzdata
#   Timezone
# zip
#   Make a zip file
# unzip
#   Unzip zip file
# curl
#   Transfer data from or to a server
# wget
#   Network downloader
# libqt5webkit5
#   Web content engine (Fix issue in Android)
# libgconf-2-4
#   Required package for chrome and chromedriver to run on Linux
# xvfb
#   X virtual framebuffer
# gnupg
#   Encryption software. It is needed for nodejs
# salt-minion
#   Infrastructure management (client-side)
# gcc g++ 
#   node and python dependancies
# python 
#   flask server and robotframework dependancies
# git 
#   version control
#==================
RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
    openjdk-8-jdk \
    ca-certificates \
    tzdata \
    zip \
    unzip \
    curl \
    wget \
    libqt5webkit5 \
    libgconf-2-4 \
    apt-utils \
    xvfb \
    gnupg \
    sudo \
    gcc \
    g++ \
    make \
    git \
    salt-minion \
#    python3 \
#    python3-dev \
#    python3-pip \
    && rm -rf /var/lib/apt/lists/*

#===============
# Set JAVA_HOME
#===============
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre" \
    PATH=$PATH:$JAVA_HOME/bin

#=====================
# Install Android SDK
#=====================
ARG SDK_VERSION=sdk-tools-linux-3859397
ARG ANDROID_BUILD_TOOLS_VERSION=26.0.0
ARG ANDROID_PLATFORM_VERSION="android-25"

ENV SDK_VERSION=$SDK_VERSION \
    ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION \
    ANDROID_HOME=/root

RUN wget -O tools.zip https://dl.google.com/android/repository/${SDK_VERSION}.zip && \

    unzip tools.zip && rm tools.zip && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin

RUN mkdir -p ~/.android && \

    touch ~/.android/repositories.cfg && \
    echo y | sdkmanager "platform-tools" && \
    echo y | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    echo y | sdkmanager "platforms;$ANDROID_PLATFORM_VERSION"

ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

#====================================
# Install latest nodejs, npm, appium
#====================================
RUN  curl -sL https://deb.nodesource.com/setup_13.x | bash - && \

     apt-get install -y nodejs && \
     apt-get autoremove --purge -y && \
     sudo npm install -g --unsafe-perm=true --allow-root appium && \
     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

#====================================
# Install robotframework and other python requirements
#====================================
RUN pip install --no-cache-dir allure-robotframework robotframework robotframework-extendedrequestslibrary \ 
    robotframework-faker robotframework-jsonlibrary robotframework-jsonvalidator robotframework-pabot \ 
    robotframework-randomlibrary robotframework-requests robotframework-seleniumlibrary robotframework-databaselibrary \
    RESTinstance robotframework-pabot

#================================
# APPIUM Test Distribution (ATD)
#================================
ARG ATD_VERSION=1.2
ENV ATD_VERSION=$ATD_VERSION
RUN wget -nv -O RemoteAppiumManager.jar "https://github.com/AppiumTestDistribution/ATD-Remote/releases/download/${ATD_VERSION}/RemoteAppiumManager-${ATD_VERSION}.jar"

#==================================
# Fix Issue with timezone mismatch
#==================================
ENV TZ="US/Pacific"
RUN echo "${TZ}" > /etc/timezone

#===============
# Expose Ports
#---------------
# 4723
#   Appium port
# 4567
#   ATD port
#===============
EXPOSE 4723
EXPOSE 4567

#====================================================
# Scripts to run appium and connect to Selenium Grid
#====================================================
#COPY entry_point.sh \
#     generate_config.sh \
#     wireless_connect.sh \
#     wireless_autoconnect.sh \
#     /root/
#RUN chmod +x /root/entry_point.sh && \
#    chmod +x /root/generate_config.sh && \
#    chmod +x /root/wireless_connect.sh && \
#    chmod +x /root/wireless_autoconnect.sh
#========================================
# Run xvfb and appium server
#========================================
#CMD /root/wireless_autoconnect.sh && /root/entry_point.sh

RUN node -v 
RUN npm -v
RUN java -version
RUN python3 -V
RUN sdkmanager --list
RUN sdkmanager --update
RUN adb devices

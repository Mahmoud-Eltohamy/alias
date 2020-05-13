FROM python:3.8-alpine
# Installs Android SDK
ENV ANDROID_SDK_FILENAME android-sdk_r26.0.2-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-29 
ENV ANDROID_BUILD_TOOLS_VERSION 21.1.0
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

#####################################################################

ARG NODE_VER=8.11.3
ARG NPM_VER=5

RUN apk -U --no-cache add curl git make gcc g++ python linux-headers paxctl libgcc libstdc++ binutils-gold ca-certificates \
 && cd /tmp \
 && curl --silent --ssl https://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER.tar.gz | tar zxf - \
 && cd node-v$NODE_VER \
 && ./configure --prefix=/usr \
 && make -j1 && make install \
 && paxctl -cm /usr/bin/node \
 && npm install -g npm@$NPM_VER \
 && find /usr/lib/node_modules/npm -name test -o -name .bin -type d \
 | xargs rm -rf \
 && apk del \
    curl \
    git \
    make \
    gcc \
    g++ \
    python \
    linux-headers \
    paxctl \
    grep \
    binutils-gold \
    ca-certificates \
 && rm -rf \
    /tmp/* \
    /var/cache/apk/* \
    /root/.npm \
    /root/.node-gyp \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    /usr/share/man

CMD ["node", "-v"]

###############################################################

RUN apk update && apk --no-cache add openjdk7 bash && \
    mkdir /opt ; exit 0 && cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo y | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} --no-https && \
    rm /var/cache/apk/*    

RUN pip install allure-robotframework robotframework robotframework-extendedrequestslibrary robotframework-faker \
    robotframework-jsonlibrary robotframework-jsonvalidator robotframework-pabot robotframework-randomlibrary \
    robotframework-requests robotframework-seleniumlibrary robotframework-databaselibrary \
    RESTinstance robotframework-pabot

CMD ["node", "-v"]
CMD ["adb", "devices"]
CMD ["python", "-V"]

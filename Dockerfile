FROM python:3.11-alpine

# Installs Android SDK
ENV ANDROID_SDK_FILENAME android-sdk_r26.0.2-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-20,android-21,android-27,android-29 
ENV ANDROID_BUILD_TOOLS_VERSION 21.1.0
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN apk update && apk add openjdk7 bash && \
    mkdir /opt ; exit 0 && cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo y | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} --no-https && \
    rm /var/cache/apk/*    

RUN pip3 install allure-robotframework robotframework robotframework-extendedrequestslibrary robotframework-faker \
    robotframework-jsonlibrary robotframework-jsonvalidator robotframework-pabot robotframework-randomlibrary \
    robotframework-requests robotframework-screencaplibrary robotframework-seleniumlibrary robotframework-databaselibrary \
    RESTinstance robotframework-pabot

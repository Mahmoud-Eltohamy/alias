FROM ubuntu:latest
#ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -f --quiet -y python3.8 python3-pip unzip firefox wget npm nodejs  \
    openjdk-8-jdk libgconf2-4 libnss3 libxss1 libappindicator1 libindicator7 xdg-utils
# android-sdk android-sdk-platform-23    
RUN wget --no-verbose https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg --install google-chrome-stable_current_amd64.deb; apt-get --fix-broken --assume-yes install
RUN pip3 install allure-robotframework robotframework robotframework-extendedrequestslibrary robotframework-faker \
    robotframework-jsonlibrary robotframework-jsonvalidator robotframework-pabot robotframework-randomlibrary \
    robotframework-requests robotframework-screencaplibrary robotframework-seleniumlibrary robotframework-databaselibrary \
    RESTinstance robotframework-pabot locustio python-owasp-zap-v2.4 sqlmap jupyterhub dbbot
RUN CHROMEDRIVER_VERSION=`wget --no-verbose --output-document - https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget --no-verbose --output-document /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver && \
    chmod +x /opt/chromedriver/chromedriver && \
    ln -fs /opt/chromedriver/chromedriver /usr/local/bin/chromedriver
RUN GECKODRIVER_VERSION=`wget --no-verbose --output-document - https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep tag_name | cut -d '"' -f 4` && \
    wget --no-verbose --output-document /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar --directory /opt -zxf /tmp/geckodriver.tar.gz && \
    chmod +x /opt/geckodriver && \
    ln -fs /opt/geckodriver /usr/local/bin/geckodriver
#RUN wget -O android_sdk_setup.sh https://raw.githubusercontent.com/MoshDev/AutoFramer/master/android_sdk_setup.sh &&  bash android_sdk_setup.sh --full
RUN wget --no-verbose https://github.com/zaproxy/zaproxy/releases/download/v2.9.0/zaproxy_2.9.0-1_all.deb && dpkg --install zaproxy_2.9.0-1_all.deb; apt-get --fix-broken --assume-yes install

# Download and untar Android SDK tools
RUN mkdir -p /usr/local/android-sdk-linux && \
    wget --no-verbose https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O tools.zip && \
    unzip -qq tools.zip -d /usr/local/android-sdk-linux && \
    rm tools.zip

# Set environment variable
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Make license agreement
RUN mkdir $ANDROID_HOME/licenses && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
    echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 24333f8a63b6825ea9c5514f83c2829b004d1fee >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license

# Update and install using sdkmanager
RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3" "build-tools;27.0.3" && \
    $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28" "platforms;android-27" && \
    $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository"


RUN java -version 
RUN adb --version 
RUN sdkmanager --no_https --list

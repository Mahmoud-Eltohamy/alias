FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get update && apt-get install -f --quiet -y python3-pip unzip firefox wget npm nodejs  \
    openjdk-8-jdk libgconf2-4 libnss3 libxss1 libappindicator1 libindicator7 xdg-utils  

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 


#RUN wget --no-verbose https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN dpkg --install google-chrome-stable_current_amd64.deb; apt-get --fix-broken --assume-yes install
RUN pip3 install allure-robotframework robotframework robotframework-extendedrequestslibrary robotframework-faker \
    robotframework-jsonlibrary robotframework-jsonvalidator robotframework-pabot robotframework-randomlibrary \
    robotframework-requests robotframework-screencaplibrary robotframework-seleniumlibrary robotframework-databaselibrary \
    RESTinstance robotframework-pabot locustio python-owasp-zap-v2.4 sqlmap jupyterhub dbbot
#RUN CHROMEDRIVER_VERSION=`wget --no-verbose --output-document - https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
#    wget --no-verbose --output-document /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
#    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver && \
#    chmod +x /opt/chromedriver/chromedriver && \
#    ln -fs /opt/chromedriver/chromedriver /usr/local/bin/chromedriver
#RUN GECKODRIVER_VERSION=`wget --no-verbose --output-document - https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep tag_name | cut -d '"' -f 4` && \
#    wget --no-verbose --output-document /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
#    tar --directory /opt -zxf /tmp/geckodriver.tar.gz && \
#    chmod +x /opt/geckodriver && \
#    ln -fs /opt/geckodriver /usr/local/bin/geckodriver
#RUN wget -O android_sdk_setup.sh https://raw.githubusercontent.com/MoshDev/AutoFramer/master/android_sdk_setup.sh &&  bash android_sdk_setup.sh --full
#RUN wget --no-verbose https://github.com/zaproxy/zaproxy/releases/download/v2.9.0/zaproxy_2.9.0-1_all.deb && dpkg --install zaproxy_2.9.0-1_all.deb; apt-get --fix-broken --assume-yes install
RUN  conda install -c auto bit.recipe.android_sdk 
RUN java -version 
RUN adb --version
RUN conda --version

RUN sdkmanager --no_https --list

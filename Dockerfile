FROM ruby:2.3
MAINTAINER hiroaki0404@gmail.com

# build:
#  docker build -t se-ruby .
# run:
#  docker run -P -v your_test_folder_in_host:/test -d se-ruby
## Use your ssh client on host to access this container, with X forwarding option.
## login: docker
## password: docker

# Java8
RUN echo deb http://http.debian.net/debian jessie-backports main >> /etc/apt/sources.list
RUN apt-get update -y && apt-get install -y openssh-server openjdk-8-jre iceweasel-l10n-ja sudo locales fonts-ipafont && sed -i 's/#.*ja_JP\.UTF/ja_JP\.UTF/' /etc/locale.gen && locale-gen && update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8
RUN curl "http://selenium-release.storage.googleapis.com/3.0/selenium-server-standalone-3.0.1.jar" -o /opt/selenium-server-standalone.jar
RUN gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2/
RUN bundle config build.nokogiri --use-system-libraries
RUN /usr/sbin/useradd -m docker -G sudo -s /bin/bash
RUN /bin/echo 'docker:docker' | /usr/sbin/chpasswd

EXPOSE 22
CMD /etc/init.d/ssh start && java -jar /opt/selenium-server-standalone.jar

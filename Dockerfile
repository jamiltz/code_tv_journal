FROM ubuntu:14.04

RUN apt-get update -q
RUN apt-get install -qy python-software-properties software-properties-common
RUN add-apt-repository -y ppa:brightbox/ruby-ng
RUN apt-get update -q
RUN apt-get install -qy nginx ruby2.1 ruby2.1-dev nodejs sqlite3 libsqlite3-dev zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev git-core curl libpq-dev
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir -p /var/www
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN /bin/bash -l -c "bundle install"

ADD ./ /var/www/journal
ADD config/journal.conf /etc/nginx/sites-enabled/journal
ADD config/start_server.sh /usr/bin/start_server
RUN chmod +x /usr/bin/start_server
RUN mkdir -p /var/www/journal/tmp/pids
RUN mkdir -p /var/www/journal/tmp/sockets
RUN mkdir -p /var/www/journal/log

WORKDIR /var/www/journal

EXPOSE 80

ENTRYPOINT /usr/bin/start_server

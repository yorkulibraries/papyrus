FROM ruby:3.1.4-bullseye

WORKDIR /app

ARG NODE_VER
ENV NODE_VER $NODE_VER

ADD https://deb.nodesource.com/setup_${NODE_VER:-lts}.x  /tmp/setup_nodejs.x 
RUN chmod a+x /tmp/setup_nodejs.x 
RUN /tmp/setup_nodejs.x 

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
build-essential curl git nodejs vim sqlite3 chromium chromium-driver libvips

RUN npm install --global yarn

ADD Gemfil[e] /app/
ADD Gemfile.loc[k] /app/
ADD .ruby-versio[n] /app/

RUN if [ -f Gemfile ] ; then bundle install ; fi
RUN if [ ! -f Gemfile ] ; then gem install rails ; fi

ADD https://raw.githubusercontent.com/yorkulibraries/docker-rails/main/rt.sh /usr/local/bin/rt
RUN chmod a+x /usr/local/bin/rt


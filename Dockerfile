FROM ubuntu:16.04
MAINTAINER David Gethings <dgethings@juniper.net>

# define the build and ruby packages the app needs
ENV BUILD_PACKAGES libmagickwand-dev
ENV RUBY_PACKAGES ruby bundler

# create and use app dir
RUN mkdir /usr/app
WORKDIR /usr/app

# copy bundler files to app dir for when we run bundler
COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/

# put the ruby script in the app dir
COPY grapher.rb /usr/app

# Update and install all of the required packages.
# At the end, remove the apt lists (the cache is auto cleaned)
RUN apt-get update && \
    apt-get -y install $BUILD_PACKAGES && \
    apt-get -y install $RUBY_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

# now install the required gems
RUN bundle install

# run the script
ENTRYPOINT /usr/app/grapher.rb

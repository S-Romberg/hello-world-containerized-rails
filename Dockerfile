FROM ruby:2.5-alpine
RUN bundle config --global frozen 1 && gem install bundler \
 && apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  sqlite-dev \
  tzdata \
  nodejs yarn postgresql-client \
  && rm -rf /var/cache/apk/*

# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN bundle config build.nokogiri --use-system-libraries

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install 

COPY . .

RUN yarn install && rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

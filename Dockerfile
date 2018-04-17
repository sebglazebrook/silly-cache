FROM ruby:latest

WORKDIR /app

COPY Gemfile* /app/

RUN bundle install

COPY . /app/

# CMD bundle exec rackup

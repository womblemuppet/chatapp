FROM ruby:latest

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

COPY . .

ENTRYPOINT ["bundle", "exec", "rackup", "-p", "7888", "--host", "0.0.0.0"]

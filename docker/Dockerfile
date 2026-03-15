# Rails Performance Lab - Docker image for running the lab
# Ruby 3.3 + Rails 7.x

FROM ruby:3.3-alpine

RUN apk add --no-cache \
    build-base \
    libpq-dev \
    postgresql-client \
    nodejs \
    tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock* ./
RUN bundle install -j4

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

FROM ruby:2.7.5-alpine

RUN apk add git &&\
    apk update && \
    apk add --virtual build-dependencies build-base
RUN gem install bundle

WORKDIR /app

COPY Gemfile .

RUN bundle config path vendor/bundle && bundle install

COPY . .

CMD ["sleep", "infinity"]

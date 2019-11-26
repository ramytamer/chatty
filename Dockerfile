FROM ruby:2.5

RUN apt-get update -qq \
  && apt-get install -y mysql-client

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . .

ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 3000

CMD [ "rails", "s", "-b", "0.0.0.0" ]
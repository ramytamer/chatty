FROM ruby:2.5.7

RUN apt-get update -qq \
  && apt-get install -y default-mysql-client --no-install-recommends \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . .

ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 3000

CMD [ "rails", "s", "-b", "0.0.0.0" ]
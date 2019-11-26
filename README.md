# Chatty

This is a simple chat Rails application.

# Booting up

1. First you will need to configure the required environment variables defined in `docker-compose.yml` file,
you can find some of them in `.env.example` file so you can start by `cp .env.example .env` and make your modifications
to the `.env` file.

2. Then you will need to build your docker images, run `docker-compose build` to do so.

3. After that you will need to create and migrate your database to make sure that your app is functioning correctly,
executing `docker-compose run app rake db:create db:migrate`.

4. Finally you can boot up the server using this command `docker-compose up`; this will boot all the required services
like the database, redis...

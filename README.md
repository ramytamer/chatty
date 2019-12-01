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

# Testing and Linting

1. To run your tests you need to run the same commands but in the `test` env using
    1. `docker-compose exec -e RAILS_ENV=test app rake db:create db:migrate` to create and migrate the database.
    2. `docker-compose esec -e RAILS_ENV=test app rspec` to run the test suite.

2. You can also run `rubocop` to make sure that your code is well-linted using `docker-compose exec app rubocop`;
you can also append `-a` option to the `rubocop` command to autofix offences if there is any fixable ones.

3. You can also use nodemon to automate running the tests:
    1. First install nodemon `npm i -g nodemon`.
    2. Then run the rspec and rubocop on change of any ruby file in the project
    `nodemon -w . --exec "clear && docker-compose exec -T -e RAILS_ENV=test app 'rspec' && docker-compose exec -T app 'rubocop'" --ext rb`

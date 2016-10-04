# academy

[![Build Status](https://travis-ci.org/ClubNix/academy.svg?branch=master)](https://travis-ci.org/ClubNix/academy)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/ClubNix/academy.svg)](https://beta.hexfaktor.org/github/ClubNix/academy)
[![Prod Deps Status](https://beta.hexfaktor.org/badge/prod/github/ClubNix/academy.svg)](https://beta.hexfaktor.org/github/ClubNix/academy)
[![Inline docs](http://inch-ci.org/github/ClubNix/academy.svg)](http://inch-ci.org/github/ClubNix/academy)

A member skill database

## Run

- Install Elixir, [Phoenix](http://www.phoenixframework.org/docs/installation), Node.js, npm, and PostgreSQL
- Create the file `/config/dev.secret.exs` using the template described in `/config/dev.exs`
- run `mix deps.get` and `npm install`
- Setup the database
	- Start the PostgreSQL service
	- Check the credentials in the config files (`/config` directory)
	- Run `mix ecto.setup` to create the database and tables and populate the skill related tables
- run `mix phoenix.server`

## Deploy in production

To setup the database, see the "Run" section.

- Configure with the prod environment in mind the `config/prod.exs` and
  `config/prod.secret.exs` files.
- Ensure that all dependencies are here, and compile everything:
```
MIX_ENV=prod mix do deps.get, compile
```
- Compile and digest the assests
```
node_modules/brunch/bin/brunch build --production
MIX_ENV=prod mix phoenix.digest
```
- Build the release tar
```
MIX_ENV=prod mix release --env=prod [--upgrade]
```
- Upload it to the server
	- If it is the first time, unpack it wherever you want.
	- If it is an upgrade, copy it to the "academy/releases/x.x.x/" folder (depending on the release version) and do `./bin/academy upgrade x.x.x` (hot code upgrade!)
	- Do `./bin/academy command Elixir.Release.Tasks migrate` to run database migrations.

- Run it with `./bin/academy start` (`./bin/academy` to see available commands)
- Profit !

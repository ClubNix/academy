# academy

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

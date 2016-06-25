use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :academy, Academy.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :academy, Academy.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :academy, Academy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "academy_dev",
  hostname: "localhost",
  pool_size: 10

config :guardian, Guardian,
  secret_key: %{"k" => "o8miWfgDbuWnyEEefDxIGQ", "kty" => "oct"}

# ===================================
# == Example dev.secret.exs config ==
# ===================================

#use Mix.Config
#
#config :academy, Academy.Endpoint.LDAP,
#  host: "ldap.my-organisation.org",
#  base: "dc=myorganisation,dc=org",
#  where: "People",
#  ssl: true,
#  port: 636

import_config "dev.secret.exs"

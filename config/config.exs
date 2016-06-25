# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :academy, ecto_repos: [Academy.Repo]

# Configures the endpoint
config :academy, Academy.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "EXmrrXmAac2VyZegEbEWcxGGtoJFYWKHfOnD7+Po31+nY03uUbng1ajttjEHwuux",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Academy.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Academy",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  serializer: Academy.UserSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

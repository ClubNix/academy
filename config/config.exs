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
           adapter: Phoenix.PubSub.PG2],
  instrumenters: [Academy.Metrics.PhoenixInstrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["ES512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Academy",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  serializer: Academy.UserSerializer

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :alchemic_avatar,
  colors_palette: :iwanthue,
  app_name: :academy

config :academy, Academy.Mailer.Limits,
  count: 10,
  every: 60

config :prometheus, Academy.Metrics.PhoenixInstrumenter,
  controller_call_labels: [:controller, :action],
  duration_buckets: [10, 25, 50, 100, 250, 500, 1000, 2500, 5000,
                     10_000, 25_000, 50_000, 100_000, 250_000, 500_000,
                     1_000_000, 2_500_000, 5_000_000, 10_000_000],
  registry: :default,
  duration_unit: :microseconds

config :prometheus, Academy.Metrics.PipelineInstrumenter,
  labels: [:status_class, :method, :host, :scheme, :request_path],
  duration_buckets: [10, 100, 1_000, 10_000, 100_000,
                     300_000, 500_000, 750_000, 1_000_000,
                     1_500_000, 2_000_000, 3_000_000],
  registry: :default,
  duration_unit: :microseconds

config :academy, Academy.Repo,
  loggers: [Academy.Metrics.RepoInstrumenter]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

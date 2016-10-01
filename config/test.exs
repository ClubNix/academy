use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :academy, Academy.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :academy, Academy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "academy_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :academy, Academy.Endpoint.LDAP,
  host: "localhost",
  base: "dc=test,dc=com",
  where: "People",
  ssl: false,
  port: 3389

config :academy, Academy.Mailer,
  domain: "https://api.mailgun.net/v3/something.mailgun.org",
  key: "key-omgponiesomgponiesomgponiesomgponies",
  mail: "Awesomeness <postmaster@something.mailgun.org>",
  mode: :test,
  test_file_path: "/tmp/mail.json"

config :guardian, Guardian,
  secret_key: %{"k" => "o8miWfgDbuWnyEEefDxIGQ", "kty" => "oct"}

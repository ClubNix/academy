use Mix.Config

config :academy, Academy.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

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

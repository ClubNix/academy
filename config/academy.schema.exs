@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [],
  mappings: [
    "logger.level": [
      commented: false,
      datatype: :atom,
      default: :info,
      doc: "Choose the logging level for the console backend.",
      hidden: false,
      to: "logger.level",
      datatype: [enum: [:debug, :info, :warn, :error]]
    ],
    "guardian.Elixir.Guardian.secret_key": [
      commented: false,
      datatype: Conform.Types.JWK,
      doc: "A secret key to sign user session tokens. **MANDATORY**",
      hidden: false,
      to: "guardian.Elixir.Guardian.secret_key"
    ],
    "academy.Elixir.Academy.Endpoint.http.port": [
      commented: false,
      datatype: :integer,
      default: 80,
      doc: "The port to run the application to.",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.http.port"
    ],
    "academy.Elixir.Academy.Endpoint.url.host": [
      commented: false,
      datatype: :binary,
      default: "academy.clubnix.fr",
      doc: "The host name for the application.",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.url.host"
    ],
    "academy.Elixir.Academy.Endpoint.url.port": [
      commented: false,
      datatype: :integer,
      default: 80,
      doc: "The port for generated inside URLs (should be the same as the http port)",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.url.port"
    ],
    "academy.Elixir.Academy.Endpoint.secret_key_base": [
      commented: false,
      datatype: :binary,
      doc: "A secret key used as a base to generate secrets for encrypting and signing data. Can be generated using `mix phoenix.gen.secret`. **MANDATORY**",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.secret_key_base"
    ],
    "academy.Elixir.Academy.Repo.username": [
      commented: false,
      datatype: :binary,
      default: "postgres",
      doc: "The username for the PostgreSQL server.",
      hidden: false,
      to: "academy.Elixir.Academy.Repo.username"
    ],
    "academy.Elixir.Academy.Repo.password": [
      commented: false,
      datatype: :binary,
      default: "postgres",
      doc: "The password for the PostgreSQL server.",
      hidden: false,
      to: "academy.Elixir.Academy.Repo.password"
    ],
    "academy.Elixir.Academy.Repo.database": [
      commented: true,
      datatype: :binary,
      default: "academy_prod",
      doc: "The the name of database to use.",
      hidden: false,
      to: "academy.Elixir.Academy.Repo.database"
    ],
    "academy.Elixir.Academy.Repo.hostname": [
      commented: true,
      datatype: :binary,
      default: "localhost",
      doc: "The hostname of the PostgreSQL server.",
      hidden: false,
      to: "academy.Elixir.Academy.Repo.hostname"
    ],
    "academy.Elixir.Academy.Repo.pool_size": [
      commented: true,
      datatype: :integer,
      default: 20,
      doc: "The number of connections to the database.",
      hidden: false,
      to: "academy.Elixir.Academy.Repo.pool_size"
    ],
    "academy.Elixir.Academy.Endpoint.LDAP.host": [
      commented: false,
      datatype: :binary,
      default: "ldap.my-organisation.org",
      doc: "The host of the LDAP server.",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.LDAP.host"
    ],
    "academy.Elixir.Academy.Endpoint.LDAP.base": [
      commented: false,
      datatype: :binary,
      default: "dc=myorganisation,dc=org",
      doc: "The base DN of the LDAP",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.LDAP.base"
    ],
    "academy.Elixir.Academy.Endpoint.LDAP.where": [
      commented: false,
      datatype: :binary,
      default: "People",
      doc: "Where the users are in the LDAP (the \"ou=\" field)",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.LDAP.where"
    ],
    "academy.Elixir.Academy.Endpoint.LDAP.ssl": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Use SSL?",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.LDAP.ssl"
    ],
    "academy.Elixir.Academy.Endpoint.LDAP.port": [
      commented: false,
      datatype: :integer,
      default: 636,
      doc: "The port used to connect to the LDAP (default: non-ssl: 389, ssl: 636)",
      hidden: false,
      to: "academy.Elixir.Academy.Endpoint.LDAP.port"
    ]
  ],
  transforms: [],
  validators: []
]

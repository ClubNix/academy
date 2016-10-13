defmodule Academy.Mixfile do
  use Mix.Project

  def project do
    [app: :academy,
     version: "0.1.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps,
     source_url: "https://github.com/ClubNix/academy",
     homepage_url: "https://github.com/ClubNix/academy",
     docs: [extras: ["README.md"]]]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Academy, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger,
                    :gettext, :phoenix_ecto, :postgrex, :eldap, :guardian,
                    :arc, :arc_ecto, :alchemic_avatar, :mailgun, :earmark,
                    :runtime_tools, :prometheus_ex, :prometheus_ecto,
                    :prometheus_phoenix, :prometheus_plugs,
                    :prometheus_process_collector]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(:travis), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:arc, "~> 0.5.2"},
     {:arc_ecto, "~> 0.4.2"},
     {:alchemic_avatar, "~> 0.1.0"},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:guardian, "~> 0.12.0"},
     {:mailgun, "~> 0.1.2"},
     {:earmark, "~> 1.0"},
     {:poison, "~> 2.1", override: true},
     {:distillery, "~> 0.10"},
     {:prometheus_ex, "~> 1.0"},
     {:prometheus_ecto, "~> 1.0"},
     {:prometheus_phoenix, "~> 1.0"},
     {:prometheus_plugs, "~> 1.0"},
     {:prometheus_process_collector, "~> 1.0"},
     {:credo, "~> 0.4", only: [:dev, :test]},
     {:inch_ex, "~> 0.5", only: [:dev, :test, :travis]},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end

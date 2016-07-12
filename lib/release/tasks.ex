defmodule Release.Tasks do
  @moduledoc ~S"""
  Tasks to be done when creating / upgrading a production environment.
  """

  @spec migrate() :: :ok

  @doc ~S"""
  Migrate the database. Equivalent to the `mix ecto.migrate` command.
  """
  def migrate() do
    {:ok, _} = Application.ensure_all_started(:academy)

    path = Application.app_dir(:academy, "priv/repo/migrations")

    Ecto.Migrator.run(Academy.Repo, path, :up, all: true)

    :init.stop()
  end

end

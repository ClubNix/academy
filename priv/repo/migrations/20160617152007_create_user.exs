defmodule Academy.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :available, :boolean

      timestamps
    end

  end
end
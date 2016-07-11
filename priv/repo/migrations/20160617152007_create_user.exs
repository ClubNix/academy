defmodule Academy.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :bio, :text
      add :available, :boolean
      add :avatar, :string

      add :email, :string, null: true
      add :show_email, :boolean, default: false
      add :github_username, :string, null: true

      timestamps
    end

  end
end

defmodule Academy.Repo.Migrations.CreateSkillCategory do
  use Ecto.Migration

  def change do
    create table(:skill_categories) do
      add :name, :string

      timestamps
    end
    create unique_index(:skill_categories, [:name])

  end
end

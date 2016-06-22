defmodule Academy.Repo.Migrations.CreateSkill do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :description, :string

      add :skill_category_id, references(:skill_categories)

      timestamps
    end
    create unique_index(:skills, [:name])

  end
end

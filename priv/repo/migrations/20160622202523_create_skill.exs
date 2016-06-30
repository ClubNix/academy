defmodule Academy.Repo.Migrations.CreateSkill do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :description, :string

      add :category_id, references(:skill_categories, on_delete: :nilify_all)

      timestamps
    end
    create unique_index(:skills, [:name])

  end
end

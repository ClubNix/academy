defmodule Academy.Repo.Migrations.CreateSkillLevels do
  use Ecto.Migration

  def change do
    create table(:skill_levels) do
      add :level, :integer

      add :user_id, references(:users, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)
    end
    create unique_index(:skill_levels, [:user_id, :skill_id])

  end
end

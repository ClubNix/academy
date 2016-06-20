defmodule Academy.Repo.Migrations.CreateSkillLevel do
  use Ecto.Migration

  def change do
    create table(:skill_levels) do
      add :level, :integer

      timestamps
    end

  end
end

defmodule Academy.API.SkillLevelView do

  use Academy.Web, :view

  def render("show.json", %{skill_level: skill_level}) do
    %{
      id: skill_level.id,
      user_id: skill_level.user_id,
      skill: render_one(skill_level.skill, Academy.API.SkillView, "show.json"),
      level: skill_level.level
    }
  end

end

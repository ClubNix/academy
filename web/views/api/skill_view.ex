defmodule Academy.API.SkillView do

  use Academy.Web, :view

  def render("index.json", %{skills: skills}) do
    render_many(skills, Academy.API.SkillView, "show.json")
  end

  def render("show.json", %{skill: skill}) do
    %{
      id: skill.id,
      name: skill.name,
      category: render_one(skill.category, Academy.API.SkillCategoryView, "show.json")
    }
  end

end

defmodule Academy.API.SkillCategoryView do

  use Academy.Web, :view

  def render("index.json", %{skill_categories: skill_categories}) do
    render_many(skill_categories, Academy.API.SkillCategoryView, "show.json")
  end

  def render("show.json", %{skill_category: skill_category}) do
    %{
      id: skill_category.id,
      name: skill_category.name,
    }
  end

end

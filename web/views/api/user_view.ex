defmodule Academy.API.UserView do

  use Academy.Web, :view

  def render("index.json", %{users: users}) do
    render_many(users, Academy.API.UserView, "show.json")
  end

  def render("show.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      skill_levels: render_many(user.skill_levels, Academy.API.SkillLevelView, "show.json")
    }
  end

end

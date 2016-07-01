defmodule Academy.API.SkillCategoryController do
  @moduledoc ~S"""
  Controller for API skill category related routes
  """

  use Academy.Web, :controller

  alias Academy.Repo

  alias Academy.SkillCategory
  
  def index(conn, _params) do
    render conn, skill_categories: Repo.all(SkillCategory)
  end

  def show(conn, %{"id" => id}) do
    render conn, skill_category: Repo.get(SkillCategory, id)
  end
  
end

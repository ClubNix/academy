defmodule Academy.SkillView do
  @moduledoc ~S"""
  Module used to render skill related pages (e.g. Available skills page).
  """

  use Academy.Web, :view

  alias Academy.SkillCategoryView

  @doc ~S"""
  Get the category name of the given skill, or "No category" if it doesn't have
  one.
  """
  def category_name(skill) do
    SkillCategoryView.name(skill.category)
  end

end

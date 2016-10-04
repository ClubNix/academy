defmodule Academy.SkillCategoryView do
  @moduledoc ~S"""
  Module used to render skill categories related pages.
  """

  use Academy.Web, :view

  @doc ~S"""
  Get the name of the given category, or "No category" if it is nil.
  """
  def name(category) do
    case category do
      nil -> "No category"
      _ -> category.name
    end
  end

end

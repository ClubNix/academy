defmodule Academy.API.SkillLevelController do
  @moduledoc ~S"""
  Controller for api skill levels related routes
  """

  use Academy.Web, :controller

  alias Academy.Repo

  alias Academy.SkillLevel

  def show(conn, %{"id" => id}) do
    render conn, skill_level: SkillLevel |> Repo.get(id) |> Repo.preload(skill: :category)
  end
  
end

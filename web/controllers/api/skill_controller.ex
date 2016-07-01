defmodule Academy.API.SkillController do
  @moduledoc ~S"""
  Controller for API skill related routes
  """

  use Academy.Web, :controller

  alias Academy.Repo

  alias Academy.Skill
  
  def index(conn, _params) do
    render conn, skills: Skill |> Repo.all |> Repo.preload(:category)
  end

  def show(conn, %{"id" => id}) do
    render conn, skill: Skill |> Repo.get(id) |> Repo.preload(:category)
  end
  
end

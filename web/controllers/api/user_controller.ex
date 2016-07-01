defmodule Academy.API.UserController do
  @moduledoc ~S"""
  Controller for API user related routes
  """

  use Academy.Web, :controller

  alias Academy.Repo

  alias Academy.User
  alias Academy.Avatar

  @doc ~S"""
  Show all users
  """
  def index(conn, _params) do
    render conn, users: User |> Repo.all |> Repo.preload(skills: :category)
  end

  def show(conn, %{"id" => id}) do
    render conn, user: User |> Repo.get(id) |> Repo.preload(skills: :category)
  end

end

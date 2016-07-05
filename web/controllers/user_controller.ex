defmodule Academy.UserController do
  @moduledoc ~S"""
  Controller for user related routes
  """

  use Academy.Web, :controller

  alias Academy.Repo

  alias Academy.User
  alias Academy.Avatar

  alias Academy.SessionController

  require Logger

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__] when not action in [:show, :index]
  plug :scrub_params, "user" when action in [:update]

  @doc ~S"""
  Show all users (front page)
  """
  def index(conn, _params) do
    render conn, "all.html", users: User |> Repo.all |> Repo.preload(:skills)
  end

  def edit(conn, _params) do
    current_user = SessionController.current_user(conn)
    render conn, "edit.html", user: current_user, changeset: User.changeset(current_user)
  end

  def show(conn, %{"id" => username}) do
    case Repo.get_by(User, name: username) do
      nil -> conn
             |> put_status(404)
             |> render(Academy.ErrorView, :"404")
      user -> render conn, "full-card.html", user: user |> Repo.preload([skills: :category])
    end
  end

  @doc ~S"""
  Show the full card of the current user.

  This is actually a redirection to show with the good `id`
  """
  def show_self(conn, _params) do
    user = SessionController.current_user(conn)
    redirect(conn, to: user_path(conn, :show, user.name))
  end

  def update(conn, %{"user" => user_params}) do
    user_params = Map.update!(user_params, "bio", fn value ->
      case value do
        "" -> nil
        _  -> value
      end
    end)

    user = SessionController.current_user(conn)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user.name))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn) do

  end

  @doc ~S"""
  Get a user by name, creating it if he does not exists
  """
  def get_or_create(username) do
    case Repo.get_by(User, name: username) do
      nil -> create(username)
      user -> user
    end
  end

  defp create(username) do
    Logger.info("Creating user #{username} in database")
    user = Repo.insert! User.changeset(%User{name: username}, %{})
    generated_avatar = AlchemicAvatar.generate(String.capitalize(user.name), 100)
    Avatar.store {generated_avatar, user}
    user
  end

  @doc ~S"""
  Function called if the user is not authenticated and tried to view a page
  requiring authentication
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Academy.ErrorView, :"401")
  end

end

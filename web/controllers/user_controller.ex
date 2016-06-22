defmodule Academy.UserController do
  use Academy.Web, :controller
  alias Academy.Repo
  alias Academy.User
  alias Academy.SessionController

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__] when not action in [:show, :index]

  def index(conn, _params) do
    render conn, "all.html", users: User |> Repo.all |> Repo.preload([skill_levels: :skill])
  end

  def edit(conn, %{"id" => username}) do
    current_user = SessionController.current_user(conn)
    if username !== current_user.name do
      conn
      |> put_status(401)
      |> render(Academy.ErrorView, :"401")
    else
      render conn, "edit.html", user: current_user, changeset: User.changeset(current_user)
    end
  end

  def show(conn, %{"id" => username}) do
    case Repo.get_by(User, name: username) do
      nil -> conn
             |> put_status(404)
             |> render(Academy.ErrorView, :"404")
      user -> render conn, "full-card.html", user: user |> Repo.preload([skill_levels: :skill])
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user_params = Map.update!(user_params, "bio", fn value ->
      case value do
        "" -> nil
        _  -> value
      end
    end)

    user = Repo.get!(User, id)
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

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Academy.ErrorView, :"401")
  end

end

defmodule Academy.UserController do
  use Academy.Web, :controller
  alias Academy.Repo
  alias Academy.User
  alias Academy.SessionController

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__] when not action in [:show, :index]

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

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Academy.ErrorView, :"401")
  end

end

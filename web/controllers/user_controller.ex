defmodule Academy.UserController do
  use Academy.Web, :controller
  alias Academy.Repo
  alias Academy.User
  alias Academy.Session

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__] when not action in [:show, :index]

  def index(conn, _params) do
    render conn, "all.html", users: User |> Repo.all |> Repo.preload([skill_levels: :skill])
  end

  def edit(conn, %{"id" => username}) do
    current_user = Session.current_user(conn)
    if username !== current_user.name do
      conn
      |> put_status(401)
      |> render(Academy.ErrorView, :"401")
    else

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

  def update(conn, params) do

  end

  def delete(conn) do

  end

end

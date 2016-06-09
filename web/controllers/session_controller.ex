defmodule Academy.SessionController do
  use Academy.Web, :controller

  def new(conn, _params) do
    render conn, "login.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Academy.Session.login(session_params) do
      :ok ->
        username = session_params["login"]
        conn |> put_session(:current_user, username)
             |> put_flash(:info, "You are now logged in as: #{username}")
             |> redirect(to: "/")
      {:error, reason} ->
        case reason do
          :invalidCredentials ->
            conn |> put_flash(:error, "Wrong email or password")
                 |> render("login.html")
          _ ->
            conn |> put_flash(:error, "Internal error. Please try again.")
                 |> render("login.html")
        end
    end
  end

  def delete(conn, _) do
    if Academy.Session.logged_in?(conn) do
      conn |> delete_session(:current_user)
           |> put_flash(:info, "Logged out")
           |> redirect(to: "/")
    else
      conn |> put_flash(:error, "You are not logged in")
           |> redirect(to: "/")
    end
  end
end

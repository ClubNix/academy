defmodule Academy.SessionController do
  use Academy.Web, :controller
  alias Academy.User

  def new(conn, _params) do
    if Academy.Session.logged_in?(conn) do
      conn
        |> put_flash(:warn, "You already are logged in")
        |> redirect(to: page_path(conn, :index))
    else
      render conn, "login.html"
    end
  end

  def create(conn, %{"session" => session_params}) do
    if Academy.Session.logged_in?(conn) do
      conn
        |> put_flash(:warn, "You already are logged in")
        |> redirect(to: page_path(conn, :index))
    else
      case Academy.Session.login(session_params) do
        {:ok, user = %User{}} ->
          username = user.username
          conn
            |> Guardian.Plug.sign_in(user)
            |> put_flash(:info, "You are now logged in as: #{username}")
            |> redirect(to: page_path(conn, :index))
        {:error, reason} ->
          case reason do
            :missing_field ->
              conn
                |> put_flash(:error, "Please ensure all required fields are filled")
                |> redirect(to: session_path(conn, :new))
            :invalid_credentials ->
              conn
                |> put_flash(:error, "Wrong email or password")
                |> redirect(to: session_path(conn, :new))
            _ ->
              conn
                |> put_flash(:error, "Internal error. Please try again.")
                |> redirect(to: session_path(conn, :new))
          end
      end
    end
  end

  def delete(conn, _) do
    if Academy.Session.logged_in?(conn) do
      conn
        |> Academy.Session.logout
        |> put_flash(:info, "Logged out")
        |> redirect(to: page_path(conn, :index))
    else
      conn
        |> put_flash(:error, "You are not logged in")
        |> redirect(to: page_path(conn, :index))
    end
  end
end

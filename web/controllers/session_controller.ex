defmodule Academy.SessionController do
  use Academy.Web, :controller
  alias Academy.User

  require Logger

  def new(conn, _params) do
    if logged_in?(conn) do
      conn
        |> put_flash(:warn, "You already are logged in")
        |> redirect(to: user_path(conn, :index))
    else
      render conn, "login.html"
    end
  end

  def create(conn, %{"session" => session_params}) do
    if logged_in?(conn) do
      conn
        |> put_flash(:warn, "You already are logged in")
        |> redirect(to: user_path(conn, :index))
    else
      case login(session_params) do
        {:ok, username} ->
          handle_login(conn, username)
        {:error, reason} ->
          handle_error(conn, reason)
      end
    end
  end

  def delete(conn, _) do
    if logged_in?(conn) do
      conn
      |> logout
      |> put_flash(:info, "Logged out")
      |> redirect(to: user_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You are not logged in")
      |> redirect(to: user_path(conn, :index))
    end
  end

  defp handle_login(conn, username) do
    user = User.get_or_create(username)
    conn
    |> Guardian.Plug.sign_in(user)
    |> put_flash(:info, "You are now logged in as #{String.capitalize user.name}")
    |> redirect(to: user_path(conn, :index))
  end

  defp handle_error(conn, error) do
    conn = case error do
      :missing_field ->
        put_flash(conn, :error, "Please ensure all required fields are filled")
      :invalid_credentials ->
        put_flash(conn, :error, "Wrong username or password")
      _ ->
        put_flash(conn, :error, "Internal error. Please try again.")
    end
    render conn, "login.html"
  end

  def login(%{"username" => username, "password" => password}) when username != "" and password != "" do
    case Academy.Endpoint.LDAP.check_credentials(username, password) do
      :ok ->
        Logger.info("User #{username} successfully authenticated to LDAP")
        {:ok, username}
      {:error, :invalid_credentials} ->
        Logger.info("User #{username} failed to authenticate to LDAP: Wrong login/password.")
        {:error, :invalid_credentials}
      {:error, error_msg} ->
        Logger.warn("User #{username} failed to authenticate to LDAP: #{error_msg}")
        {:error, error_msg}
    end
  end

  def login(_params), do: {:error, :missing_field}

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def logged_in?(conn) do
    !!current_user(conn)
  end

end

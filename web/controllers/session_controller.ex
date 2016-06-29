defmodule Academy.SessionController do
  @moduledoc ~S"""
  Module controlling user sessions.
  """

  use Academy.Web, :controller
  alias Academy.UserController

  require Logger

  @doc ~S"""
  Render the login page if the user is not logged in
  """
  def new(conn, _params) do
    if logged_in?(conn) do
      conn
        |> put_flash(:warn, "You already are logged in")
        |> redirect(to: user_path(conn, :index))
    else
      render conn, "login.html"
    end
  end

  @doc ~S"""
  Check the credentials and log the given user.

  See the `login/1` function and `Academy.Endpoint.LDAP` module.
  """
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

  @doc ~S"""
  Log out the current user
  """
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

  @doc ~S"""
  Function called after a successful credentials verification.

  Log the user using the `Guardian` module and return it, creating it if it
  does not exists. This function also generates an avatar for the newly created
  user.
  """
  defp handle_login(conn, username) do
    user = UserController.get_or_create(username)
    conn
    |> Guardian.Plug.sign_in(user)
    |> put_flash(:info, "You are now logged in as #{String.capitalize user.name}")
    |> redirect(to: user_path(conn, :index))
  end

  @doc ~S"""
  Function called on authentication failure.
  """
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

  @doc ~S"""
  Check the given credentials using the `Academy.Endpoint.LDAP` module.

  Returns `{:ok, username}` on success and `{:error, error_msg}` on failure.
  """
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

  @doc ~S"""
  Log out the given user using the `Guardian` module
  """
  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  @doc ~S"""
  Return the currently logged user
  """
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  @doc ~S"""
  Return true if a user is logged in for the current connection, false otherwise
  """
  def logged_in?(conn) do
    !!current_user(conn)
  end

end

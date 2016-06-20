defmodule Academy.Session do
  alias Academy.User
  require Logger

  def login(%{"username" => username, "password" => password}) when username != "" and password != "" do
    case Academy.Endpoint.LDAP.check_credentials(username, password) do
      :ok ->
        Logger.info("User #{username} successfully authenticated to LDAP")
        {:ok, username}
      {:error, :invalidCredentials} ->
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

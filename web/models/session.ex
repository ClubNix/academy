defmodule Academy.Session do
  alias Academy.User
  require Logger

  def login(params) do
    case status = Academy.Endpoint.LDAP.check_credentials(params["username"], params["password"]) do
      :ok -> Logger.info("User #{params["username"]} successfully authenticated to LDAP")
      {:error, errMsg} -> Logger.info("User #{params["username"]} failed to authenticate to LDAP: #{errMsg}")
    end
    status
  end

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def logged_in?(conn) do
    !!current_user(conn)
  end
end

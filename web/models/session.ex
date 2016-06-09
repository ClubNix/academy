defmodule Academy.Session do
  alias Academy.User
  require Logger

  def login(params) do
    case status = Academy.Endpoint.LDAP.check_credentials(params["login"], params["password"]) do
      :ok -> Logger.info("User #{params["login"]} successfully authenticated to LDAP")
      {:error, errMsg} -> Logger.info("User #{params["login"]} failed to authenticate to LDAP: #{errMsg}")
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

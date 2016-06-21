defmodule Academy.Endpoint.LDAP do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: LDAP)
  end

  def init(:ok) do
    settings = Application.get_env :academy, Academy.Endpoint.LDAP

    host = Dict.get(settings, :host) |> :erlang.binary_to_list
    ssl = Dict.get(settings, :ssl, false)
    port = Dict.get(settings, :port, 389)

    Logger.info("Connecting to ldap#{if ssl, do: "s"}://#{host}:#{port}")

    :ssl.start
    {:ok, ldap_conn} = :eldap.open([host], ssl: ssl, port: port)
    Logger.info("Connected to LDAP")
    {:ok, ldap_conn}
  end

  def terminate(_reason, ldap_conn) do
    :eldap.close(ldap_conn)
    Logger.info("Stopped LDAP")
  end

  def handle_call({:authenticate, username, password}, _from, ldap_conn) do
    settings = Application.get_env :academy, Academy.Endpoint.LDAP

    base  = Dict.get(settings, :base, "")          |> :erlang.binary_to_list
    where = Dict.get(settings, :where, "People")   |> :erlang.binary_to_list

    status = :eldap.simple_bind(ldap_conn,
     'uid=' ++ ldap_escape(username) ++ ',ou=' ++ where ++ ',' ++ base,
     password)

   case status do
     :ok -> {:reply, status, ldap_conn}
     {:error, :invalidCredentials} -> {:reply, {:error, :invalid_credentials}, ldap_conn}
     {:error, :anonymous_auth} -> {:reply, status, ldap_conn}
    end

  end

  def check_credentials(username, password) when is_list(username) and is_list(password) do
    GenServer.call(LDAP, {:authenticate, username, password})
  end

  def check_credentials(username, password) do
    check_credentials(:erlang.binary_to_list(username), :erlang.binary_to_list(password))
  end

  def ldap_escape(''), do: ''

  def ldap_escape([char | rest]) do
    escaped_char = case char do
      ?,  -> '\\,'
      ?#  -> '\\#'
      ?+  -> '\\+'
      ?<  -> '\\<'
      ?>  -> '\\>'
      ?;  -> '\\;'
      ?"  -> '\\\"'
      ?=  -> '\\='
      ?\\ -> '\\\\'
      _   -> [char]
    end
    escaped_char ++ ldap_escape(rest)
  end

end

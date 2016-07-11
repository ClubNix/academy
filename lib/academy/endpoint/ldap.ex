defmodule Academy.Endpoint.LDAP do
  @moduledoc ~S"""
  Module handling the ldap credential verifications

  Configuration
  -------------

  The configuration should be in the dev.secret.exs or prod.secret.exs depending
  on the environment you're working on. Here's an example config:

      config :academy, Academy.Endpoint.LDAP,
        host: "ldap.my-organisation.org",
        base: "dc=myorganisation,dc=org",
        where: "People",
        ssl: true,
        port: 636

  The `:host` key is mandatory. By default, it establish a non SSL
  connection with 389 as port. The default `:base` is nothing, and the default
  `:where`, corresponding to the `ou` key in a LDAP structure is `"People"`.
  """

  use GenServer
  require Logger

  unless Application.get_env(:academy, Academy.Endpoint.LDAP) do
    raise "Please configure the LDAP in the config files"
  end

  @settings Application.get_env :academy, Academy.Endpoint.LDAP

  unless Dict.get(@settings, :host) do
    raise "I need a LDAP host to work. Please put it in the config files"
  end

  @host Dict.get(@settings, :host) |> :erlang.binary_to_list
  @ssl  Dict.get(@settings, :ssl, false)
  @port Dict.get(@settings, :port, 389)

  @base  Dict.get(@settings, :base, "")        |> :erlang.binary_to_list
  @where Dict.get(@settings, :where, "People") |> :erlang.binary_to_list

  @doc ~S"""
  Start the LDAP process.

  This function is called by the supervisor handled by the Application `Academy`
  in `Academy.start/2`.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: LDAP)
  end

  @doc ~S"""
  Init the LDAP connection.

  This is called by the `GenServer.start_link/3` function. GenServer will then
  handle and keep the state, which is in this case the ldap connection, and
  pass it we we need it.
  """
  def init(:ok) do
    Logger.info("Connecting to ldap#{if @ssl, do: "s"}://#{@host}:#{@port}")

    :ssl.start
    {:ok, ldap_conn} = :eldap.open([@host], ssl: @ssl, port: @port)
    Logger.info("Connected to LDAP")
    {:ok, ldap_conn}
  end

  @doc ~S"""
  Terminate the LDAP connection.

  Called by GenServer when the process is stopped.
  """
  def terminate(_reason, ldap_conn) do
    :eldap.close(ldap_conn)
    Logger.info("Stopped LDAP")
  end

  def handle_call({:authenticate, username, password}, _from, ldap_conn) do
    status = :eldap.simple_bind(ldap_conn,
     'uid=' ++ ldap_escape(username) ++ ',ou=' ++ @where ++ ',' ++ @base,
     password)

   case status do
     :ok -> {:reply, status, ldap_conn}
     {:error, :invalidCredentials} -> {:reply, {:error, :invalid_credentials}, ldap_conn}
     {:error, :anonymous_auth} -> {:reply, status, ldap_conn}
    end

  end

  @doc ~S"""
  Check the given credentials.

  Because we are using an Erlang library, we must convert the username and
  password to a list of chars instead of an Elixir string.
  """
  def check_credentials(username, password) when is_list(username) and is_list(password) do
    GenServer.call(LDAP, {:authenticate, username, password})
  end

  def check_credentials(username, password) do
    check_credentials(:erlang.binary_to_list(username), :erlang.binary_to_list(password))
  end

  @doc ~S"""
  Escape special LDAP characters in a string.
  """
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

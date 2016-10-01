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

  @type ldap_conn :: :eldap.handle
  @type auth_status :: :ok | {:error, atom}

  @spec start_link() :: Genserver.on_start

  @doc ~S"""
  Start the LDAP process.

  This function is called by the supervisor handled by the Application `Academy`
  in `Academy.start/2`.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: LDAP)
  end

  @spec init(:ok) :: {:ok, ldap_conn}

  @doc ~S"""
  Init the LDAP connection.

  This is called by the `GenServer.start_link/3` function. GenServer will then
  handle and keep the state, which is in this case the ldap connection, and
  pass it we we need it.
  """
  def init(:ok) do

    settings = Application.get_env :academy, Academy.Endpoint.LDAP

    host = Dict.get(settings, :host) |> :erlang.binary_to_list
    ssl  = Dict.get(settings, :ssl, false)
    port = Dict.get(settings, :port, 389)

    base  =  Dict.get(settings, :base, "")        |> :erlang.binary_to_list
    where =  Dict.get(settings, :where, "People") |> :erlang.binary_to_list

    Logger.info("Connecting to ldap#{if ssl, do: "s"}://#{host}:#{port}")

    :ssl.start
    {:ok, ldap_conn} = :eldap.open([host], ssl: ssl, port: port)
    Logger.info("Connected to LDAP")

    {:ok, {ldap_conn, base, where}}
  end

  @type reason :: :normal | :shutdown | {:shutdown, term} | term

  @spec terminate(reason, {ldap_conn, list, list}) :: :ok

  @doc ~S"""
  Terminate the LDAP connection.

  Called by GenServer when the process is stopped.
  """
  def terminate(_reason, {ldap_conn, base, where}) do
    :eldap.close(ldap_conn)
    Logger.info("Stopped LDAP")
  end

  def handle_call({:authenticate, username, password}, _from, {ldap_conn, base, where}) do
    status = :eldap.simple_bind(ldap_conn,
     'uid=' ++ ldap_escape(username) ++ ',ou=' ++ where ++ ',' ++ base,
     password)

   case status do
     :ok -> {:reply, status, {ldap_conn, base, where}}
     {:error, :invalidCredentials} -> {:reply, {:error, :invalid_credentials}, {ldap_conn, base, where}}
     {:error, :anonymous_auth} -> {:reply, status, {ldap_conn, base, where}}
    end

  end

  @spec check_credentials(charlist | binary, charlist | binary) :: boolean

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

  @spec ldap_escape(charlist) :: charlist

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

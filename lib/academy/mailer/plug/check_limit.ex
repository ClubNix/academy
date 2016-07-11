defmodule Academy.Mailer.Plug.CheckLimit do
  @moduledoc ~S"""
  Handle the limit checking of mail sending.

  To be used as a Plug.

  ## Example usage

      plug Academy.Mailer.CheckLimit, handler: MyModule

  If the user has reached the mail limit, the function
  `MyModule.mail_limit_reached/2` will be called, with the `conn` and its
  `params`.

  ## Example config

      config :academy, Academy.Mailer.Limits,
        count: 10,
        every: 60
  """

  require Logger

  import Plug.Conn

  @config Application.get_env(:academy, Academy.Mailer.Limits, [])
  @count Keyword.get(@config, :count, 10)
  @every Keyword.get(@config, :every, 60)

  def init(options) do
    %{
      handler: Keyword.get(options, :handler),
      handler_func: :mail_limit_reached
    }
  end

  def call(conn, options) do
    count = get_session(conn, :mail_count)
    ts = get_session(conn, :mail_ts)
    if check(count, ts) do
      conn
    else
      handle_error conn, options
    end
  end

  defp handle_error(%Plug.Conn{params: params} = conn, options) do
    Logger.warn("User attempted to send to many email. Current user: #{get_current_username(conn)}")

    conn = halt conn

    mod  = options.handler
    func = options.handler_func

    apply(mod, func, [conn, params])
  end

  defp check(count, ts) when count == nil or ts == nil, do: true

  defp check(count, ts) do
    if :os.system_time(:seconds) - ts > @every do
      true
    else
      count < @count
    end
  end

  defp get_current_username(conn) do
    case Academy.SessionController.current_user(conn) do
      nil -> "nil"
      user -> user.name
    end
  end

end

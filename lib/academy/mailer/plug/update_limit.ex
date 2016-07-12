defmodule Academy.Mailer.Plug.UpdateLimit do
  @moduledoc ~S"""
  Update the limit status for the current connection.

  To be used as a Plug.

  The limit must be checked (see `Academy.Mailer.Plug.CheckLimit`) before.

  This Plug will update the mail sent count for the current connection as if
  the user sent a mail.

  ## Example config

      config :academy, Academy.Mailer.Limits,
        count: 10,
        every: 60
  """

  import Plug.Conn

  @config Application.get_env(:academy, Academy.Mailer.Limits, [])
  @every Keyword.get(@config, :every, 60)

  @doc false
  def init(_options), do: false

  @spec call(Plug.Conn.t, false) :: Plug.Conn.t

  @doc ~S"""
  Call the plug.

  Will update the current limit status regarding the current connection.
  """
  def call(conn, _options) do
    count   = get_session_field(conn, :mail_count, 0)
    last_ts = get_session_field(conn, :mail_ts, 0)

    current_ts = :os.system_time(:seconds)

    {count, ts} = if current_ts - last_ts > @every do
      {0, current_ts}
    else
      {count + 1, last_ts}
    end

    conn
    |> put_session(:mail_count, count)
    |> put_session(:mail_ts, ts)
  end

  defp get_session_field(conn, key, default \\ nil) do
    case get_session(conn, key) do
      nil -> default
      value -> value
    end
  end

end

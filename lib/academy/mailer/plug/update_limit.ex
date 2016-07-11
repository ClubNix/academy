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

  use Plug.Builder

  plug Plug.Logger

  import Plug.Conn

  @config Application.get_env(:academy, Academy.Mailer.Limits, [])
  @every Keyword.get(@config, :every, 60)

  def init(_options), do: false

  def call(conn, _options) do
    count = Map.get(conn.private, :academy_mail_count, 0)
    last_ts    = Map.get(conn.private, :academy_mail_ts, 0)

    current_ts = :os.system_time(:seconds)

    {count, ts} = if current_ts - last_ts > @every do
      {0, current_ts}
    else
      {count + 1, last_ts}
    end

    conn
    |> put_private(:academy_mail_count, count)
    |> put_private(:academy_mail_ts, ts)
  end

end

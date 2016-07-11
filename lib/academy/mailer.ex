defmodule Academy.Mailer do
  @moduledoc ~S"""
  Module that takes charge of sending email to those who do not want their
  email visible.

  You should probably plug `Academy.Mailer.Plug.CheckLimit` and
  `Academy.Mailer.Plug.UpdateLimit` to avoid mail spamming.

  ## Example config

      config :academy, Academy.Mailer,
        domain: "https://api.mailgun.net/v3/academy.example.org",
        key: "key-omgponiesomgponiesomgponiesomgponiesomgponies",
        mail: "Awesomeness <mailer@academy.example.org>",
        mode: :test,
        test_file_path: "/tmp/mail.json"

  The optional `mode: :test` and `test_file_path: ...` will make the mailer
  store the emails in the given file instead of actually sending them.

  """

  unless Application.get_env(:academy, Academy.Mailer) do
    raise "Please configure the Mailer in the config files"
  end

  @config Application.get_env(:academy, Academy.Mailer)
  @mail Keyword.get(@config, :mail)

  use Mailgun.Client, @config

  def send(subject, message, recipient) do
    # TODO: Better HTML escaping (HTML special chars are too much escaped
     #      inside code blocks)
    send_email from: @mail,
               to: recipient,
               subject: "[Academy] #{subject}",
               text: message,
               html: message
                     |> Phoenix.HTML.html_escape
                     |> Phoenix.HTML.safe_to_string
                     |> Earmark.to_html
  end

end

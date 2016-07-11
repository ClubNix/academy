defmodule Academy.MailController do
  @moduledoc ~S"""
  Controller for mail related stuff.
  """

  use Academy.Web, :controller

  alias Academy.Repo
  alias Academy.User

  plug :user_has_email_address
  plug Academy.Mailer.Plug.CheckLimit, handler: __MODULE__
  plug Academy.Mailer.Plug.UpdateLimit when action == :send

  def new(conn, %{"user" => username}) do
     render conn, "new.html", username: username
  end

  def send(conn, %{"user" => username, "mail" => mail_params}) do
    Academy.Mailer.send(mail_params["subject"], mail_params["message"], conn.assigns[:recipient])
    conn
    |> put_flash(:info, "Email sent successfully")
    |> redirect(to: "/")
  end

  def mail_limit_reached(conn, _params) do
    conn
    |> put_status(429)
    |> render(Academy.ErrorView, :"429")
  end

  defp user_has_email_address(%Plug.Conn{params: %{"user" => username}} = conn, _opts) do
    email = Repo.get_by!(User, name: username).email
    if email do
      assign(conn, :recipient, email)
    else
      conn
      |> put_flash(:error, "This user did not setup his email address")
      |> redirect(to: "/")
    end
  end

end

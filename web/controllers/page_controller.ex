defmodule Academy.PageController do
  use Academy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def about(conn, _params) do
    render conn, "index.html"
  end
end

defmodule Academy.PageController do
  @moduledoc ~S"""
  The page controller.

  Currently only used to generate the about page.
  """

  use Academy.Web, :controller

  def about(conn, _params) do
    render conn, "about.html"
  end
end

defmodule Academy.ErrorView do
  @moduledoc ~S"""
  Module used to render errors.
  """

  use Academy.Web, :view

  @doc ~S"""
  Render an error.
  """
  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  def render("401.html", _assigns) do
    "Unauthorized"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  @doc ~S"""
  Function called when a template isn't found
  """
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end

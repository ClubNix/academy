defmodule Academy.ErrorView do
  @moduledoc ~S"""
  Module used to render errors.
  """

  use Academy.Web, :view

  @doc ~S"""
  Function called when a template isn't found
  """
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end

defmodule Academy.ErrorViewTest do
  use Academy.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(Academy.ErrorView, "404.html", []) =~
           "404 Not found"
  end

  test "render 500.html" do
    assert render_to_string(Academy.ErrorView, "500.html", []) =~
           "500 Server internal error"
  end

  test "render 401.html" do
    assert render_to_string(Academy.ErrorView, "401.html", []) =~
           "401 Not authorized"
  end

  test "render any other" do
    assert render_to_string(Academy.ErrorView, "505.html", []) =~
           "500 Server internal error"
  end
end

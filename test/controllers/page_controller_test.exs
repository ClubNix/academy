defmodule Academy.PageControllerTest do
  use Academy.ConnCase

  test "GET /about", %{conn: conn} do
    conn = get conn, "/about"
    assert html_response(conn, 200) =~ "Welcome to *Nix Academy"
  end
end

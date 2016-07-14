defmodule Academy.PageControllerTest do
  use Academy.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/about"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end

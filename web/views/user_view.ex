defmodule Academy.UserView do
  use Academy.Web, :view

  def generate_rating(level, max \\ 5, full_str \\ "★", empty_str \\ "☆") do
    String.duplicate(full_str, level) <> String.duplicate(empty_str, max - level)
  end

  def generate_availability_icon(true) do
    {:safe, "<div class=\"availability\" data-tooltip=\"Available\"><img src=\"/images/available.svg\" alt=\"Available\"></div>"}
  end

  def generate_availability_icon(false) do
    {:safe, "<div class=\"availability\" data-tooltip=\"Not available\"><img src=\"/images/not-available.svg\" alt=\"Available\"></div>"}
  end

  def generate_availability_icon(nil) do
    {:safe, "<div class=\"availability\" data-tooltip=\"Availability unknown\">?</div>"}
  end

end

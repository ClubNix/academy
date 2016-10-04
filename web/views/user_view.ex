defmodule Academy.UserView do
  @moduledoc ~S"""
  Module used to render user related pages.
  """

  use Academy.Web, :view

  alias Academy.SessionController
  alias Academy.Avatar

  use Phoenix.HTML

  @doc ~S"""
  Rank the given list of users according to the sum of their skill levels.
  """
  def rank_users(users) do
    users
    |> Enum.group_by(&sum_skill_levels/1)
    |> Enum.sort(fn {lrank, _lusers}, {rrank, _rusers} -> lrank > rrank end)
    |> Enum.flat_map(fn {_rank, users} -> users end)
  end

  defp sum_skill_levels(user) do
    user.skill_levels
    |> Enum.map(fn skill_level -> skill_level.level end)
    |> Enum.sum
  end

  @doc ~S"""
  Generate the HTML of the inside of the full member card
  """
  def full_ratings(skill_levels) do
    skill_levels
    |> Enum.group_by(fn skill_level -> skill_level.skill.category.name end)
    |> Enum.map(fn {category_name, skill_levels} ->
      skill_levels = Enum.sort(skill_levels, &(&1.level > &2.level))
      content_tag :div,
        [content_tag(:h2, category_name), rating_table(skill_levels)],
        class: "category"
    end)
  end

  @doc ~S"""
  Generate the HTML of the inside of the small member card
  """
  def small_ratings(skill_levels) do
    skill_length = length(skill_levels)
    if skill_length > 4 do
      split_size = round(Float.ceil(skill_length / 2))
      skill_levels
      |> Enum.chunk(split_size, split_size, [])
      |> Enum.map(fn chunk ->
        chunk
        |> Enum.sort(&(&1.level > &2.level))
        |> Enum.take(5)
      end)
      |> Enum.map(&rating_table/1)
    else
      rating_table(skill_levels)
    end
  end

  @doc ~S"""
  Generate the HTML of a rating table

  Just the table of the association skill name / rating
  """
  def rating_table(skill_levels) do
    content_tag :table do
      Enum.map(skill_levels, fn skill_level ->
        content_tag :tr do
          [content_tag(:td, skill_level.skill.name, class: "skill-name tooltip",
            data: [tooltip: skill_level.skill.description]),
           content_tag(:td, rating(skill_level.level), class: "rating")]
        end
      end)
    end
  end

  @doc ~S"""
  Generate the stars for the given rating
  """
  def rating(level, max \\ 5, full_str \\ "★", empty_str \\ "☆") do
    String.duplicate(full_str, level) <> String.duplicate(empty_str, max - level)
  end

  @doc ~S"""
  Generate the HTML for the avatar picture of the current member.

  See `Academy.Avatar`
  """
  def avatar(user) do
    {:safe, "<img src=\"#{avatar_url user}\" alt=\"Profile picture\" class=\"profile-picture\">"}
  end

  @doc ~S"""
  Get the URI of the given user's avatar.
  """
  def avatar_url(user) do
    Avatar.url({user.avatar, user})
  end

  @doc ~S"""
  Generate the HTML of the availability icon for a member card
  """
  def availability_icon(true) do
    {:safe, "<div class=\"availability tooltip\" data-tooltip=\"Available\"><img src=\"/images/available.svg\" alt=\"Available\"></div>"}
  end

  def availability_icon(false) do
    {:safe, "<div class=\"availability tooltip\" data-tooltip=\"Unavailable\"><img src=\"/images/not-available.svg\" alt=\"Available\"></div>"}
  end

  def availability_icon(nil) do
    {:safe, "<div class=\"availability tooltip\" data-tooltip=\"Availability unknown\">?</div>"}
  end

  @doc ~S"""
  Generate the HTML for the full card's edit buttons

  This will return `nil` if the given username is not the current user's name.
  """
  def edit_buttons(conn, username) do
    user = SessionController.current_user(conn)
    if user do
      case user.name do
        ^username ->
          content_tag :div, [class: "edit-buttons"] do
            [link("✎",
              class: "edit-button tooltip",
              data: [tooltip: "Edit profile"],
              to: user_path(conn, :edit)),
            link("★",
              class: "edit-button tooltip",
              data: [tooltip: "Edit skills"],
              to: skill_level_path(conn, :edit))]
          end
        _ -> nil
      end
    end
  end

end

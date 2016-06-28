defmodule Academy.SkillLevelController do
  use Academy.Web, :controller

  alias Academy.Repo
  alias Academy.User
  alias Academy.Skill
  alias Academy.SkillLevel
  alias Academy.SkillCategory
  alias Academy.SessionController

  import Ecto.Query, only: [where: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__]

  def edit(conn, _params) do
    user = SessionController.current_user(conn)

    skill_categories =
      Repo.all(SkillCategory)
      |> Enum.map(fn category ->
          [category: category,
           skills: Skill |> where([], category_id: ^category.id) |> Repo.all]
        end)

    render conn, "edit.html",
      user: user |> Repo.preload([:skills]),
      skill_categories: skill_categories
  end

  def update(conn, params) do
    user = SessionController.current_user(conn) |> Repo.preload(:skills)

    Enum.each(params["skill_levels"], fn {"skill_" <> skill_id, level} ->
        skill_id = String.to_integer(skill_id)
        case level do
          "0" -> remove_level(user, skill_id)
          _ -> add_level(user, skill_id, String.to_integer(level))
        end
      end)

    conn
    |> put_flash(:info, "Skills successfully changed")
    |> redirect(to: user_path(conn, :show, user.name))
  end

  def find_skill_level(user, skill_id) do
    Enum.find(user.skill_levels, fn user_skill_level ->
      user_skill_level.skill.id == skill_id
    end)
  end

  defp remove_level(user, skill_id) do
    SkillLevel
    |> where([], user_id: ^user.id, skill_id: ^skill_id)
    |> Repo.delete_all
  end

  defp add_level(user, skill_id, level) do
      case find_skill_level(user, skill_id) do
        nil -> Repo.insert(
          SkillLevel.changeset(
            %SkillLevel{level: level,
                        user_id: user.id,
                        skill_id: skill_id}, %{}))
        skill_level -> Repo.update(
          SkillLevel.changeset(skill_level, %{level: level}))
      end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Academy.ErrorView, :"401")
  end

end

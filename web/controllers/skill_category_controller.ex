defmodule Academy.SkillCategoryController do
  @moduledoc ~S"""
  The skill category controller
  """

  use Academy.Web, :controller

  alias Academy.Repo
  alias Academy.Skill
  alias Academy.SkillCategory

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__]

  def edit(conn, %{"id" => skill_id}) do
    render conn, "edit.html", changeset: SkillCategory
                                         |> Repo.get(skill_id)
                                         |> SkillCategory.changeset
  end

  def update(conn, %{"id" => skill_id, "skill_category" => skill_cat_params}) do
    changeset = SkillCategory
                |> Repo.get(skill_id)
                |> SkillCategory.changeset(skill_cat_params)

    case Repo.update(changeset) do
      {:ok, _skill_category} ->
        conn
        |> put_flash(:info, "Skill category successfully updated")
        |> redirect(to: skill_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset
    end
  end

  def new(conn, _params) do
    render conn, "new.html", changeset: SkillCategory.changeset(%SkillCategory{})
  end

  def create(conn, %{"skill_category" => skill_cat_params}) do
    changeset = SkillCategory.changeset(%SkillCategory{}, skill_cat_params)

    case Repo.insert(changeset) do
      {:ok, _skill_category} ->
        conn
        |> put_flash(:info, "Skill category successfully created")
        |> redirect(to: skill_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def delete(conn, %{"id" => skill_cat_id}) do
    SkillCategory
    |> Repo.get!(skill_cat_id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Skill category successfully deleted")
    |> redirect(to: skill_path(conn, :index))
  end

end

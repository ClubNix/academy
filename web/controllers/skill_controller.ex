defmodule Academy.SkillController do
  @moduledoc ~S"""
  The skill controller
  """

  use Academy.Web, :controller

  alias Academy.Repo
  alias Academy.Skill
  alias Academy.SkillCategory

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__]

  def index(conn, _params) do
    skills = Repo.all(Skill) |> Repo.preload(:category)
    render conn, "index.html", skills: skills
  end

  def edit(conn, %{"id" => skill_id}) do
    categories = SkillCategory
                  |> Repo.all
                  |> Enum.map(fn category -> {category.name, category.id} end)
    skill = Repo.get!(Skill, skill_id) |> Repo.preload(:category)
    render conn, "edit.html", skill: skill, changeset: Skill.changeset(skill), categories: categories
  end

  def update(conn, %{"id" => skill_id, "skill" => skill_params}) do
    skill = Skill
            |> Repo.get!(skill_id)
            |> Repo.preload(:category)
    category_changeset = SkillCategory
                          |> Repo.get!(skill_params["category_id"])
                          |> SkillCategory.changeset
    changeset = skill
                |> Skill.changeset(skill_params)
                |> Ecto.Changeset.put_assoc(:category, category_changeset)

    case Repo.update(changeset) do
      {:ok, _skill} ->
        conn
        |> put_flash(:info, "Skill updated successfully.")
        |> redirect(to: skill_path(conn, :index))
      {:error, changeset} ->
        categories = SkillCategory
                      |> Repo.all
                      |> Enum.map(fn category -> {category.name, category.id} end)
        render conn, "edit.html", skill: skill, changeset: changeset, categories: categories
    end
  end

  def new(conn, _params) do
    categories = SkillCategory
                  |> Repo.all
                  |> Enum.map(fn category -> {category.name, category.id} end)
    changeset = Skill.changeset(%Skill{})
    render conn, "new.html", changeset: changeset, categories: categories
  end

  def create(conn, %{"skill" => skill_params}) do
    category_changeset = SkillCategory
                          |> Repo.get!(skill_params["category_id"])
                          |> SkillCategory.changeset
    changeset = %Skill{}
                |> Skill.changeset(skill_params)
                |> Ecto.Changeset.put_assoc(:category, category_changeset)

    case Repo.insert(changeset) do
      {:ok, _skill} ->
        conn
        |> put_flash(:info, "Skill successfully created")
        |> redirect(to: skill_path(conn, :index))
      {:error, changeset} ->
        categories = SkillCategory
                      |> Repo.all
                      |> Enum.map(fn category -> {category.name, category.id} end)
        render conn, "new.html", changeset: changeset, categories: categories
    end
  end

  def delete(conn, %{"id" => skill_id}) do
    skill = Repo.get!(Skill, skill_id)
    Repo.delete!(skill)

    conn
    |> put_flash(:info, "Skill successfully deleted")
    |> redirect(to: skill_path(conn, :index))
  end

  @doc ~S"""
  Function called if the user is not authenticated and tried to view a page
  requiring authentication
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Academy.ErrorView, :"401")
  end

end

defmodule Academy.User do
  @moduledoc ~S"""
  Defines a user model.

  Composition
  -----------

  A user is composed of a name, a biography, his availability and his avatar
  (handled by the `Academy.Avatar` module).

  A user also has a number of skill levels, which are defined in the
  `Academy.SkillLevel` module.

  You can also get his bare skills (without their levels) and his skill
  categories (without the skills)

  Getting the associations
  ------------------------

  In order to get his skill levels, skills or skill categories, one must use the
  `Academy.Repo.Preload/1` function like so:

      alias Academy.Repo
      alias Academy.User

      # Will get the user and his skill levels (but not his skills, so you
      # won't have their name)
      Repo.get(User, id) |> Repo.preload(:skill_levels)

      # Will get the user and his skill levels and skills
      Repo.get(User, id) |> Repo.preload(:skills)

      # Will get the user and his skill levels, skills and skill categories
      Repo.get(User, id) |> Repo.preload(:skill_categories)
  """

  use Academy.Web, :model

  use Arc.Ecto.Schema

  schema "users" do
    field :name, :string
    field :bio, :string
    field :available, :boolean
    field :avatar, Academy.Avatar.Type
    field :email, :string
    field :show_email, :boolean, default: false
    field :github_username, :string

    has_many :skill_levels, Academy.SkillLevel
    has_many :skills, through: [:skill_levels, :skill]
    has_many :skill_categories, through: [:skills, :category]

    timestamps
  end

  @required_fields ~w(name show_email)
  @optional_fields ~w(bio available email github_username)

  @doc ~S"""
  Creates a changeset based on the `model` and `params`.

  Examples:

      alias Academy.User
      alias Academy.Repo

      # Create a new user with name "guest" and insert it in the database
      User.changeset(%User{}, name: "guest")
      |> Repo.insert!

      # Rename a user
      Repo.get_by(User, name: "guest")
      |> User.changeset(name: "guest1")
      |> Repo.update!
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, [:avatar])
    |> validate_length(:bio, min: 10, max: 140)
    |> validate_email(:email)
    |> validate_github_username(:github_username)
    #|> validate_avatar(params)
  end

  def validate_email(changeset, field) do
    email = get_field(changeset, field)
    if email !== nil do
      validate_format(changeset,
       :email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    else
      changeset
    end
  end

  @doc ~S"""
  Validate a github username in a changeset.
  """
  def validate_github_username(changeset, field) do
    username = get_field(changeset, field)
    if username !== nil do
      if Regex.match?(~r/^[[:alnum:]][[:alnum:]-]+[[:alnum:]]$/, username) and
          not String.contains?(username, "--") do
        changeset
      else
        add_error(changeset, field, "does not look like a Github username")
      end
    else
      changeset
    end
  end

  @doc ~S"""
  Validate an avatar

  Currently not working.
  """
  def validate_avatar(changeset, params) do
    # TODO: validate the size/space usage of the image
    changeset
  end

end

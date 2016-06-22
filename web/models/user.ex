defmodule Academy.User do
  use Academy.Web, :model

  require Logger

  alias Academy.User
  alias Academy.Repo

  schema "users" do
    field :name, :string
    field :bio, :string
    field :available, :boolean

    has_many :skill_levels, Academy.SkillLevel

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(bio available)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:bio, min: 10, max: 140)
  end

  def get_or_create(username) do
    case Repo.get_by(User, name: username) do
      nil -> Logger.info("Creating user #{username} in database")
        Repo.insert! User.changeset(%User{name: username}, %{})
      user -> user
    end
  end

end

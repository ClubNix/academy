defmodule Academy.User do
  use Academy.Web, :model

  use Arc.Ecto.Schema

  require Logger

  alias Academy.User
  alias Academy.Repo

  schema "users" do
    field :name, :string
    field :bio, :string
    field :available, :boolean
    field :avatar, Academy.Avatar.Type

    has_many :skill_levels, Academy.SkillLevel
    has_many :skills, through: [:skill_levels, :skill]
    has_many :skill_categories, through: [:skills, :category]

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(bio available)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, [:avatar])
    |> validate_length(:bio, min: 10, max: 140)
    #|> validate_avatar(params)
  end

  def validate_avatar(changeset, params) do
    IO.inspect params
    changeset
  end

end

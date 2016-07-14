defmodule Academy.Skill do
  @moduledoc ~S"""
  Defines a skill model.

  Composition
  -----------

  A skill is composed of a name, a description and an association with
  `Academy.SkillCategory`

  For getting the associations, see `Academy.User`.
  """

  use Academy.Web, :model

  schema "skills" do
    field :name, :string
    field :description, :string

    belongs_to :category, Academy.SkillCategory, on_replace: :nilify

    timestamps
  end

  @required_fields ~w(name description category_id)a
  @optional_fields ~w()
  @fields @required_fields ++ @optional_fields

  @doc """
  Creates a changeset based on the `model` and `params`.

  For examples of how this works, see `Academy.User.changeset/2`.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:description, min: 10, max: 50)
    |> assoc_constraint(:category)
  end
end

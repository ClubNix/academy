defmodule Academy.SkillCategory do
  @moduledoc ~S"""
  Defines a skill category model

  Composition
  -----------

  A skill category is only composed of a name.
  """

  use Academy.Web, :model

  schema "skill_categories" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)a
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
    |> unique_constraint(:name)
  end
end

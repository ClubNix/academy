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

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  For examples of how this works, see `Academy.User.changeset/2`.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end

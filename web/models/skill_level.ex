defmodule Academy.SkillLevel do
  @moduledoc ~S"""
  Defines a skill level model

  Composition
  -----------

  A skill category is composed of a level, and an association with a
  `Academy.User` and a `Academy.Skill`.

  For getting the associations, see `Academy.User`.
  """

  use Academy.Web, :model

  schema "skill_levels" do
    field :level, :integer

    belongs_to :user, Academy.User
    belongs_to :skill, Academy.Skill
  end

  @required_fields ~w(level user_id skill_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  For examples of how this works, see `Academy.User.changeset/2`.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_number(:level, greater_than: 0, less_than: 5)
  end
end

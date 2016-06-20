defmodule Academy.SkillLevel do
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

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:user)
  end
end

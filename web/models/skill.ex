defmodule Academy.Skill do
  use Academy.Web, :model

  schema "skills" do
    field :name, :string
    field :description, :string

    belongs_to :category, Academy.SkillCategory, on_replace: :nilify

    timestamps
  end

  @required_fields ~w(name description)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:category)
    |> validate_length(:name, min: 1)
    |> validate_length(:description, min: 10, max: 50)
  end
end

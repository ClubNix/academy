defmodule Academy.SkillTest do
  use Academy.ModelCase

  alias Academy.Skill

  @valid_attrs %{description: "some content", name: "some content", category_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Skill.changeset(%Skill{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Skill.changeset(%Skill{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "description between 10 and 50 characters" do
    attrs = %{@valid_attrs | description: ""}
    assert {:description, {"should be at least %{count} character(s)", count: 10}} in errors_on(%Skill{}, attrs)

    attrs = %{@valid_attrs | description: String.duplicate("a", 500)}
    assert {:description, {"should be at most %{count} character(s)", count: 50}} in errors_on(%Skill{}, attrs)
  end

end

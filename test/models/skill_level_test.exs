defmodule Academy.SkillLevelTest do
  use Academy.ModelCase

  alias Academy.SkillLevel

  @valid_attrs %{level: 2, user_id: 1, skill_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SkillLevel.changeset(%SkillLevel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SkillLevel.changeset(%SkillLevel{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "level between 0 and 5" do
    attrs = %{@valid_attrs | level: 42}
    assert {:level, {"must be less than or equal to %{number}", number: 5}} in errors_on(%SkillLevel{}, attrs)

    attrs = %{@valid_attrs | level: -1}
    assert {:level, {"must be greater than %{number}", number: 0}} in errors_on(%SkillLevel{}, attrs)
  end

end

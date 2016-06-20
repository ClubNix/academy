defmodule Academy.SkillLevelTest do
  use Academy.ModelCase

  alias Academy.SkillLevel

  @valid_attrs %{level: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SkillLevel.changeset(%SkillLevel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SkillLevel.changeset(%SkillLevel{}, @invalid_attrs)
    refute changeset.valid?
  end
end

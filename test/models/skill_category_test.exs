defmodule Academy.SkillCategoryTest do
  use Academy.ModelCase

  alias Academy.SkillCategory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SkillCategory.changeset(%SkillCategory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SkillCategory.changeset(%SkillCategory{}, @invalid_attrs)
    refute changeset.valid?
  end
end

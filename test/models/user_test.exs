defmodule Academy.UserTest do
  use Academy.ModelCase

  alias Academy.User

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "allow empty bio" do
    attrs = Map.put(@valid_attrs, :bio, "")
    assert User.changeset(%User{}, attrs).valid?
  end

  test "bio between 10 and 140 characters" do
    attrs = Map.put(@valid_attrs, :bio, "a")
    assert {:bio, {"should be at least %{count} character(s)", count: 10}} in errors_on(%User{}, attrs)

    attrs = Map.put(@valid_attrs, :bio, String.duplicate("a", 500))
    assert {:bio, {"should be at most %{count} character(s)", count: 140}} in errors_on(%User{}, attrs)

    attrs = Map.put(@valid_attrs, :bio, String.duplicate("a", 50))
    assert User.changeset(%User{}, attrs).valid?
  end

  test "email must be valid" do
    attrs = Map.put(@valid_attrs, :email, "blabla@bla.com")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?

    attrs = Map.put(@valid_attrs, :email, "bla.b-l_a@bla.bla.engineer")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?

    attrs = Map.put(@valid_attrs, :email, "blabla")
    assert {:email, {"has invalid format", []}} in errors_on(%User{}, attrs)
  end

  test "github username must be valid" do
    attrs = Map.put(@valid_attrs, :github_username, "bla")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
  end

  test "github username may contain single dashes" do
    attrs = Map.put(@valid_attrs, :github_username, "b-l-a")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
  end

  test "github username may be 1 or 2 characters long" do
    attrs = Map.put(@valid_attrs, :github_username, "a")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
  end

  test "github username may not have dashes at the beginning or end" do
    attrs = Map.put(@valid_attrs, :github_username, "-bla")
    assert {:github_username, {"does not look like a Github username", []}} in errors_on(%User{}, attrs)

    attrs = Map.put(@valid_attrs, :github_username, "bla-")
    assert {:github_username, {"does not look like a Github username", []}} in errors_on(%User{}, attrs)
  end

  test "github username may not have dashes multiple dashes in a row" do
    attrs = Map.put(@valid_attrs, :github_username, "bla--bla")
    assert {:github_username, {"does not look like a Github username", []}} in errors_on(%User{}, attrs)
  end

  test "github username may not contain other special characters" do
    attrs = Map.put(@valid_attrs, :github_username, "bla_bla")
    assert {:github_username, {"does not look like a Github username", []}} in errors_on(%User{}, attrs)

    attrs = Map.put(@valid_attrs, :github_username, "bla@bla")
    assert {:github_username, {"does not look like a Github username", []}} in errors_on(%User{}, attrs)
  end

  test "github username may be empty" do
    attrs = Map.put(@valid_attrs, :github_username, "")
    assert User.changeset(%User{}, attrs).valid?
  end
end

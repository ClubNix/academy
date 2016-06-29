defmodule Academy.UserSerializer do
  @moduledoc ~S"""
  Module used to serialize and deserialize a user.

  Serializing is simply done by storing the username in a string,
  like so: "User:guest"

  Deserializing is done by getting the user from the database by name.

  The serialization and deserialization is automatically done by `Guardian`
  """

  @behaviour Guardian.Serializer

  alias Academy.User

  @doc ~S"""
  Serialize a user.

  This transform a user struct defined by the `Academy.User` schema to a string
  containing the username, like: "User:guest"
  """
  def for_token(user = %User{}), do: {:ok, "User:#{user.name}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  @doc ~S"""
  Deserialize a user.

  Take string serialized by `for_token/1`, and returns a user fetched from the
  database by name.
  """
  def from_token("User:" <> name), do: {:ok, Academy.Repo.get_by(User, name: name)}
  def from_token(_), do: {:error, "Unknown resource type"}
end

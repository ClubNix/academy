defmodule Academy.UserSerializer do
  @behaviour Guardian.Serializer

  alias Academy.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.username}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> username), do: {:ok, %User{username: username}}
  def from_token(_), do: {:error, "Unknown resource type"}
end

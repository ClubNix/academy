defmodule Academy.UserSerializer do
  @behaviour Guardian.Serializer

  alias Academy.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.name}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> name), do: {:ok, Academy.Repo.get_by(User, name: name)}
  def from_token(_), do: {:error, "Unknown resource type"}
end

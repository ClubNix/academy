defmodule Conform.Types.JWK do
  @moduledoc ~S"""
  Conform type for JSON Web key.
  """

  use Conform.Type
  alias Conform.Schema.Mapping

  def to_doc(_values), do: "Allowed values: A JSON Web Key. You can generate one using `mix gen.jwk`"

  def convert(nil, %Mapping{default: nil}) do
    {:error, "You must specify a JSON Web key"}
  end

  def convert(nil, %Mapping{default: default}) do
    {:ok, default}
  end
  
  def convert(binary_key, _mappings) do
    {_metadata, key} = binary_key
                      |> to_string
                      |> JOSE.JWK.from_binary
                      |> JOSE.JWK.to_map
    {:ok, key}
  end

end

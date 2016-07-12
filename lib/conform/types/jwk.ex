defmodule Conform.Types.JWK do
  @moduledoc ~S"""
  Conform type for JSON Web key.
  """

  use Conform.Type
  alias Conform.Schema.Mapping

  @spec to_doc(term) :: binary

  @doc ~S"""
  Print a nice doc message for JWK types in conform configurations.

  Callback implementation for `Conform.Type.to_doc/1`
  """
  def to_doc(_values), do: "Allowed values: A JSON Web Key. You can generate one using `mix gen.jwk`"

  @spec convert(nil | binary, Mapping.t) :: {:ok, JOSE.JWK.t} | {:error, binary}

  @doc ~S"""
  Convert a given conform configuration value to a JOSE.JWK value.
  """
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

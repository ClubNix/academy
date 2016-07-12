defmodule Mix.Tasks.Gen.Jwk do
  @moduledoc ~S"""
  Generate a EC P-521 key and output it in the JSON Web Key format.
  """

  @spec run([binary]) :: :ok

  @doc ~S"""
  Run the mix task.
  """
  def run(_args) do
    {_metadata, binary} = JOSE.JWK.generate_key(:secp521r1)
                          |> JOSE.JWK.to_binary
    Mix.shell.info binary
  end
  
end

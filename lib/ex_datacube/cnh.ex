defmodule ExDatacube.CNH do
  @moduledoc """
  Define `behaviour` com chamadas da API de CNH.

  TOOD: Implementar adaptadores.
  """

  # @moduledoc since: "0.1.1"

  alias ExDatacube.API

  @typedoc """
  CPF do motorista
  """
  @type cpf :: String.t()

  @doc """
  Retorna CNH de motorista da base nacional.
  """
  @callback consulta_nacional_cnh(cpf, ExDatacube.shared_opts()) ::
              {:ok, map()} | {:error, API.error()}
end

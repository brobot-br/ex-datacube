defmodule ExDatacube.Cadastros do
  @moduledoc """
  Define `behaviour` com chamadas da API de Cadastros.

  TOOD: Implementar adaptadores.
  """

  # @moduledoc since: "0.1.1"

  @typedoc """
  CNPJ da empresa
  """
  @type cnpj :: String.t()

  @doc """
  Retorna resultado da busca de veículos simplificada
  """
  @callback consulta_dados_cnpj(cnpj, ExDatacube.shared_opts()) ::
              {:ok, map()} | ExDatacube.authentication_error() | ExDatacube.unexpected_error()
end

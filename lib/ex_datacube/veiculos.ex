defmodule ExDatacube.Veiculos do
  @moduledoc """
  Define `behaviour` com chamadas da API de informações de veículos.
  """
  @moduledoc since: "0.1.1"

  alias ExDatacube.API
  alias ExDatacube.Veiculos.Veiculo

  @typedoc """
  Placa do veículo a ser buscada
  """
  @type placa :: String.t()

  @typedoc """
  Adaptador a ser utilizado para comunicar-se com a API.
  """
  @type adaptador :: module()

  @doc """
  Retorna resultado da busca de veículos simplificada
  """
  @callback consulta_nacional_simples_v2(placa, ExDatacube.shared_opts()) ::
              {:ok, Veiculo.t()} | {:error, API.error()}

  @doc """
  Retorna resultado da busca de veículos simplificada V3 (sem informação de proprietário)
  """
  @callback consulta_nacional_simples_v3(placa, ExDatacube.shared_opts()) ::
              {:ok, Veiculo.t()} | {:error, API.error()}

  @doc """
  Retorna resultado da busca de veículos simplificada (sem proprietário) e mais
  em conta, no entanto há a possibilidade da informação de Renavam não retornar
  na consulta.
  """
  @callback consulta_nacional_agregados(placa, ExDatacube.shared_opts()) ::
              {:ok, Veiculo.t()} | {:error, API.error()}

  @doc """
  Retorna resultado da busca de veículos completa.
  """
  @callback consulta_nacional_completa(placa, ExDatacube.shared_opts()) ::
              {:ok, Veiculo.t()} | {:error, API.error()}
end

defmodule ExDatacube.Veiculos.Adaptores.Default do
  @moduledoc """
  Implementa behaviour da api de veículos comunicando-se à API
  de produção.
  """
  @moduledoc since: "0.2.0"

  alias ExDatacube.API
  alias ExDatacube.API.Resposta
  alias ExDatacube.Veiculos
  alias ExDatacube.Veiculos.Veiculo

  require Logger

  @behaviour Veiculos

  @impl Veiculos
  def consulta_nacional_simples_v2(placa, opts) do
    params = %{placa: placa}
    path = "veiculos/informacao-simples-v2"
    opts = Keyword.update(opts, :receive_timeout, :timer.minutes(1), & &1)

    with {:ok, resposta} <- API.post(path, params, opts) do
      parse_resposta(resposta)
    end
  end

  @impl Veiculos
  def consulta_nacional_completa(placa, opts) do
    params = %{placa: placa}
    path = "veiculos/informacao-completa"
    opts = Keyword.update(opts, :receive_timeout, :timer.minutes(1), & &1)

    with {:ok, resposta} <- API.post(path, params, opts) do
      parse_resposta(resposta)
    end
  end

  # private helper
  defp parse_resposta(%Resposta{} = resposta) do
    with {:error, %Ecto.Changeset{} = changeset} <- Veiculo.new(resposta.result) do
      errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
      {:error, {:internal_server_error, "Resposta do servidor inválida: #{inspect(errors)}"}}
    end
  end
end

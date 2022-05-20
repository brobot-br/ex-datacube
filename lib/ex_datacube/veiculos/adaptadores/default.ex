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

    path
    |> API.post(params, opts)
    |> parse_results(%{path: path, params: params})
  end

  @impl Veiculos
  def consulta_nacional_completa(placa, opts) do
    params = %{placa: placa}
    path = "veiculos/informacao-completa"
    opts = Keyword.update(opts, :receive_timeout, :timer.minutes(1), & &1)

    path
    |> API.post(params, opts)
    |> parse_results(%{path: path, params: params})
  end

  # private helpers
  defp parse_results({:ok, %Resposta{status: true} = resposta}, context) do
    with {:error, changeset} <- Veiculo.new(resposta.result) do
      errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
      log_message(context, "#{inspect(errors)}")

      {:error, :unexpected_error}
    end
  end

  defp parse_results({:ok, %Resposta{status: false, code: code}}, _context)
       when code in [2, 26, 96, 764] do
    {:error, :unauthenticated}
  end

  defp parse_results({:ok, response}, context) do
    log_message(context, "#{inspect(response)}")
    {:error, :unexpected_error}
  end

  defp parse_results({:error, {:resposta_invalida, errors}}, context) do
    log_message(context, "#{inspect(errors)}")
    {:error, :unexpected_error}
  end

  defp parse_results({:error, error}, context) do
    log_message(context, "#{inspect(error)}")
    {:error, :unexpected_error}
  end

  defp log_message(context, message) do
    Logger.error(["Error requesting: ", "#{inspect(context)}", ":\n", message])
  end
end

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
    translated_result = translate_fields(resposta.result)

    with {:error, %Ecto.Changeset{} = changeset} <- Veiculo.new(translated_result) do
      errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
      {:error, {:internal_server_error, "Resposta do servidor inválida: #{inspect(errors)}"}}
    end
  end

  # não consistência de nomeclatura dos campos em consultas distintas. Na consulta
  # nacional completa, a cor do veículo retorna como `cor` e na simples como `cor_veiculo`.
  # a função abaixo padroniza os nomes para a definição no tipo `Veiculo`.
  @from_to [
    {"ano_fab", "ano_fabricacao"},
    {"cor_veiculo", "cor"},
    {"municipio_emplacamento", "municipio"},
    {"proprietario_nome", "proprietario"}
  ]
  for {from, to} <- @from_to do
    defp translate_fields(%{unquote(from) => from_value} = result) do
      result
      |> Map.put(unquote(to), from_value)
      |> Map.drop([unquote(from)])
      |> translate_fields
    end
  end

  defp translate_fields(%{} = result), do: result
end

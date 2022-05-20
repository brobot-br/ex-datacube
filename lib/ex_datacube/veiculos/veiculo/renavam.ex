defmodule ExDatacube.Veiculos.Veiculo.Renavam do
  @moduledoc """
  Representa um renavam. Inclui funções de validação e limpeza
  além de implementar o behaviour `Ecto.Type`.
  """
  @moduledoc since: "0.2.0"

  @behaviour Ecto.Type

  @type t :: String.t()

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(renavam) when is_binary(renavam), do: {:ok, format(renavam)}
  def cast(renavam) when is_number(renavam), do: {:ok, format(renavam)}
  def cast(_), do: :error

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def dump(value), do: {:ok, value}

  @impl Ecto.Type
  def equal?(a1, a2), do: a1 == a2

  @impl Ecto.Type
  def embed_as(_), do: :self

  @doc "Limpa renavam deixando somente números."
  @spec clean(String.t() | number()) :: String.t()
  def clean(renavam) when is_binary(renavam) do
    ## leave only numbers
    Regex.replace(~r/[^0-9]+/u, renavam, "")
  end

  def clean(renavam) when is_number(renavam), do: to_string(renavam) |> clean

  @doc "Limpa e preenche com zeros à esquerda retornando sempre 11 caracteres."
  @spec format(renavam :: String.t() | number()) :: renavam_formatado :: String.t()
  def format(renavam) do
    renavam
    |> clean()
    |> String.trim_leading("0")
    |> String.pad_leading(11, "0")
  end
end

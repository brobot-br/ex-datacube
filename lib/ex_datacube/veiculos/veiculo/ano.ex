defmodule ExDatacube.Veiculos.Veiculo.Ano do
  @moduledoc false
  @moduledoc since: "0.2.0"

  @behaviour Ecto.Type

  @typedoc """
  Representa um ano. Inclui funções de validação e limpeza
  além de implementar o behaviour `Ecto.Type`.
  """
  @type t :: String.t()

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(ano) when is_binary(ano), do: {:ok, format(ano)}
  def cast(ano) when is_number(ano), do: {:ok, format(ano)}
  def cast(_), do: :error

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def dump(value), do: {:ok, value}

  @impl Ecto.Type
  def equal?(a1, a2), do: a1 == a2

  @impl Ecto.Type
  def embed_as(_), do: :self

  @doc "Limpa ano deixando somente números."
  @spec clean(String.t() | number()) :: String.t()
  def clean(ano) when is_binary(ano) do
    ## leave only numbers
    Regex.replace(~r/[^0-9]+/u, ano, "")
  end

  def clean(ano) when is_number(ano), do: to_string(ano) |> clean

  @doc "Limpa e remove não dígtios"
  @spec format(ano :: String.t() | number()) :: String.t()
  def format(ano) do
    ano
    |> clean()
  end
end

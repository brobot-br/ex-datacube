defmodule ExDatacube.Veiculos.Veiculo.Boolean do
  @moduledoc """
  Representa um booleano. Converte `falsey` e `truthy` para
  booleanos com exceção de 0 que é convertido para falso.
  """
  @moduledoc since: "0.2.0"

  @behaviour Ecto.Type

  @type t :: boolean()

  @impl Ecto.Type
  def type, do: :boolean

  @impl Ecto.Type
  def cast(0), do: {:ok, false}
  def cast("0"), do: {:ok, false}
  def cast("false"), do: {:ok, false}
  def cast("FALSE"), do: {:ok, false}
  def cast(false), do: {:ok, false}
  def cast(nil), do: {:ok, nil}

  def cast(_), do: {:ok, true}

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def dump(value), do: {:ok, value}

  @impl Ecto.Type
  def equal?(a1, a2), do: a1 == a2

  @impl Ecto.Type
  def embed_as(_), do: :self
end

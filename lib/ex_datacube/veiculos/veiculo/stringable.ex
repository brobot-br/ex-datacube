defmodule ExDatacube.Veiculos.Veiculo.Stringable do
  @moduledoc false
  @moduledoc since: "0.3.1"

  @behaviour Ecto.Type

  @typedoc """
  Formato para converter para string qualquer coisa
  que implmemte protocolo `String.Chars` (útil para
  converter números).
  """
  @type t :: String.t()

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(s) when is_binary(s), do: {:ok, s}

  def cast(val) do
    if String.Chars.impl_for(val) do
      {:ok, to_string(val)}
    else
      {:error, "cannot convert to string"}
    end
  end

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def dump(value), do: {:ok, value}

  @impl Ecto.Type
  def equal?(a1, a2), do: a1 == a2

  @impl Ecto.Type
  def embed_as(_), do: :self
end

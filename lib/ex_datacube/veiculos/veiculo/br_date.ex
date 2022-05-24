defmodule ExDatacube.Veiculos.Veiculo.BRDate do
  @moduledoc false
  @moduledoc since: "0.3.1"

  @behaviour Ecto.Type

  @typedoc """
  Representa data proveniente no formato PT-BR
  (DD/MM/YYYY)
  """
  @type t :: Date.t()

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(
        <<d::bytes-size(1)>> <>
          "/" <>
          <<m::bytes-size(1)>> <>
          "/" <>
          <<y::bytes-size(4)>> <> _rest = _date
      ),
      do: {:ok, date(y, m, d)}

  def cast(
        <<d::bytes-size(1)>> <>
          "/" <>
          <<m::bytes-size(2)>> <>
          "/" <>
          <<y::bytes-size(4)>> <> _rest = _date
      ),
      do: {:ok, date(y, m, d)}

  def cast(
        <<d::bytes-size(2)>> <>
          "/" <>
          <<m::bytes-size(2)>> <>
          "/" <>
          <<y::bytes-size(4)>> <> _rest = _date
      ),
      do: {:ok, date(y, m, d)}

  def cast(
        <<d::bytes-size(2)>> <>
          "/" <>
          <<m::bytes-size(1)>> <>
          "/" <>
          <<y::bytes-size(4)>> <> _rest = _date
      ),
      do: {:ok, date(y, m, d)}

  def cast(
        <<d::bytes-size(2)>> <>
          "/" <>
          <<m::bytes-size(2)>> <>
          "/" <>
          <<y::bytes-size(2)>> = _date
      ),
      do: {:ok, date(y, m, d)}

  def cast(
        <<d::bytes-size(2)>> <>
          <<m::bytes-size(2)>> <>
          <<y::bytes-size(4)>> = _date
      ),
      do: {:ok, date(y, m, d)}

  def cast(_date) do
    {:ok, nil}
  end

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def dump(value), do: {:ok, value}

  @impl Ecto.Type
  def equal?(a1, a2), do: a1 == a2

  @impl Ecto.Type
  def embed_as(_), do: :self

  # private helpers
  defp date(<<y::bytes-size(2)>>, m, d) do
    year = String.to_integer(y) + 2000
    date(year, m, d)
  end

  defp date(y, m, d)
       when is_integer(y) and is_integer(m) and is_integer(d),
       do: %Date{year: y, month: m, day: d}

  defp date(y, m, d) when is_binary(y) do
    {y, _} = Integer.parse(y)
    date(y, m, d)
  end

  defp date(y, m, d) when is_binary(m) do
    {m, _} = Integer.parse(m)
    date(y, m, d)
  end

  defp date(y, m, d) when is_binary(d) do
    {d, _} = Integer.parse(d)
    date(y, m, d)
  end
end

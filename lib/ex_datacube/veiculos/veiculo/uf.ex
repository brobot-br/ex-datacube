defmodule ExDatacube.Veiculos.Veiculo.UF do
  @moduledoc """
  Representa uma uf brasileira. Inclui funções de validação e limpeza
  além de implementar o behaviour `Ecto.Type`.
  """
  @moduledoc since: "0.2.0"

  @behaviour Ecto.Type

  @type t :: String.t()

  @impl Ecto.Type
  def type, do: :string

  @state_to_initials_mapping [
    {"nacional", "BR"},
    {"acre", "AC"},
    {"alagoas", "AL"},
    {"amapá", "AP"},
    {"amapa", "AP"},
    {"amazonas", "AM"},
    {"bahia", "BA"},
    {"ceará", "CE"},
    {"ceara", "CE"},
    {"distrito federal", "DF"},
    {"espírito santo", "ES"},
    {"espirito santo", "ES"},
    {"goiás", "GO"},
    {"goias", "GO"},
    {"maranhão", "MA"},
    {"maranhao", "MA"},
    {"mato grosso", "MT"},
    {"mato grosso sul", "MS"},
    {"mato grosso do sul", "MS"},
    {"minas gerais", "MG"},
    {"pará", "PA"},
    {"para", "PA"},
    {"paraíba", "PB"},
    {"paraiba", "PB"},
    {"paraná", "PR"},
    {"parana", "PR"},
    {"pernambuco", "PE"},
    {"piauí", "PI"},
    {"piaui", "PI"},
    {"rio de janeiro", "RJ"},
    {"rio grande do norte", "RN"},
    {"rio grande norte", "RN"},
    {"rio grande do sul", "RS"},
    {"rio grande sul", "RS"},
    {"rondônia", "RO"},
    {"rondonia", "RO"},
    {"roraima", "RR"},
    {"santa catarina", "SC"},
    {"são paulo", "SP"},
    {"sao paulo", "SP"},
    {"sergipe", "SE"},
    {"tocantins", "TO"}
  ]
  @state_initials Enum.map(@state_to_initials_mapping, fn {_, initial} -> initial end)

  @impl Ecto.Type
  def cast(uf) when is_binary(uf) do
    case clean(uf) do
      nil ->
        :error

      cleaned_uf ->
        if cleaned_uf in @state_initials do
          {:ok, cleaned_uf}
        else
          :error
        end
    end
  end

  def cast(nil), do: {:ok, nil}
  def cast(_), do: :error

  @impl Ecto.Type
  def load(value), do: {:ok, value}

  @impl Ecto.Type
  def dump(value), do: {:ok, value}

  @impl Ecto.Type
  def equal?(a1, a2), do: a1 == a2

  @impl Ecto.Type
  def embed_as(_), do: :self

  def clean(nil), do: nil

  def clean("" <> uf) do
    uf
    |> String.trim()
    |> do_clean()
  end

  defp do_clean(<<uf::bytes-size(2)>>),
    do: String.upcase(uf)

  defp do_clean("" <> state_name) do
    state_name
    |> String.downcase()
    |> map_state_to_initials
  end

  for {state, initials} <- @state_to_initials_mapping do
    def map_state_to_initials(unquote(state)), do: unquote(initials)
  end

  def map_state_to_initials(_), do: nil
end

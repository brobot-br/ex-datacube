defmodule ExDatacube.Veiculos.Veiculo do
  @moduledoc """
  Tipo veículo que retorna em consultas
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias ExDatacube.Veiculos.Veiculo.{
    Ano,
    Boolean,
    FipePossivel,
    Gravame,
    Renavam,
    UF
  }

  @typedoc """
  Descrição de possível restrição aplicada ao veículo
  """
  @type restricao :: String.t()

  @typedoc """
  Ano como string.
  """
  @type ano :: String.t()

  @type cpf :: String.t()
  @type cnpj :: String.t()

  @type t :: %__MODULE__{
          placa: String.t(),
          renavam: Renavam.t(),
          chassi: String.t() | nil,
          uf: UF.t(),
          municipio: String.t() | nil,
          proprietario: String.t() | nil,
          proprietario_anterior: String.t() | nil,
          proprietario_documento: cpf() | cnpj() | nil,
          ano_fabricacao: ano(),
          ano_modelo: ano(),
          importado: Boolean.t(),
          marca: String.t() | nil,
          cor: String.t() | nil,
          modelo: String.t() | nil,
          tipo: String.t() | nil,
          categoria: String.t() | nil,
          capacidade_carga: String.t() | nil,
          cilindradas: String.t() | nil,
          potencia: String.t() | nil,
          eixos: String.t() | nil,
          cmt: String.t() | nil,
          combustivel: String.t() | nil,
          data_ultimo_licenciamento: Date.t() | nil,
          exercicio_ultimo_licenciamento: ano | nil,
          fipe_possivel: [FipePossivel.t()] | nil,
          restricoes: [restricao] | nil,
          gravames: Gravame.t() | nil,
          intencao_gravame: Gravame.t() | nil
        }

  @primary_key false
  @derive [Jason.Encoder]
  embedded_schema do
    field :placa, :string
    field :renavam, Renavam
    field :chassi, :string
    field :uf, UF
    field :municipio, :string
    field :proprietario, :string
    field :proprietario_anterior, :string
    field :proprietario_documento, :string
    field :ano_fabricacao, Ano
    field :ano_modelo, Ano
    field :importado, Boolean
    field :marca, :string
    field :cor, :string
    field :modelo, :string
    field :tipo, :string
    field :categoria, :string
    field :capacidade_carga, :string
    field :cilindradas, :string
    field :potencia, :string
    field :eixos, :string
    field :cmt, :string
    field :combustivel, :string
    field :data_ultimo_licenciamento, :date
    field :exercicio_ultimo_licenciamento, Ano
    embeds_many :fipe_possivel, FipePossivel, on_replace: :delete
    field :restricoes, {:array, :string}
    embeds_one :gravames, Gravame, on_replace: :update
    embeds_one :intencao_gravame, Gravame, on_replace: :update
  end

  @doc false
  def empty_values(),
    do: [
      "nao constam informacoes na base consultada",
      "NAO CONSTAM INFORMACOES NA BASE CONSULTADA",
      "indisponível"
    ]

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, __schema__(:fields) -- __schema__(:embeds), empty_values: empty_values())
    |> cast_embed(:fipe_possivel)
    |> cast_embed(:gravames)
    |> cast_embed(:intencao_gravame)
  end

  @doc """
  Cria um novo veículo a partir dos `params` fornecidos.
  """
  @spec new(params :: map) :: t()
  def new(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:insert)
  end
end

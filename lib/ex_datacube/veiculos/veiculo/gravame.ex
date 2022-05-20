defmodule ExDatacube.Veiculos.Veiculo.Gravame do
  @moduledoc """
  Representa um gravame.
  """
  @moduledoc since: "0.2.0"
  use Ecto.Schema
  import Ecto.Changeset

  alias ExDatacube.Veiculos.Veiculo

  @type t :: %__MODULE__{
          tipo_restricao_financeira: String.t(),
          nome_agente_financeiro: String.t(),
          documento: String.t(),
          nome: String.t(),
          data_inclusao: String.t()
        }

  @primary_key false
  @derive [Jason.Encoder]
  embedded_schema do
    field :tipo_restricao_financeira, :string
    field :nome_agente_financeiro, :string
    field :documento, :string
    field :nome, :string
    field :data_inclusao, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, __schema__(:fields) -- __schema__(:embeds),
      empty_values: Veiculo.empty_values()
    )
  end
end

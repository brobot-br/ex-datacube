defmodule ExDatacube.Veiculos.Veiculo.ComunicadoVenda do
  @moduledoc """
  Representa um comunicado de venda.
  """
  @moduledoc since: "0.3.0"
  use Ecto.Schema
  import Ecto.Changeset

  alias ExDatacube.Veiculos.Veiculo

  @type t :: %__MODULE__{
          situacao: String.t() | nil,
          data_inclusao: String.t() | nil,
          tipo_comprador: String.t() | nil,
          documento: String.t() | nil,
          data_venda: String.t() | nil,
          nota_fiscal: String.t() | nil,
          protocolo_detran: String.t() | nil
        }

  @primary_key false
  @derive [Jason.Encoder]
  embedded_schema do
    field :situacao, :string
    field :data_inclusao, :string
    field :tipo_comprador, :string
    field :documento, :string
    field :data_venda, :string
    field :nota_fiscal, :string
    field :protocolo_detran, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, __schema__(:fields) -- __schema__(:embeds),
      empty_values: Veiculo.empty_values()
    )
  end
end

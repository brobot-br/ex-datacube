defmodule ExDatacube.Veiculos.Veiculo.FipePossivel do
  @moduledoc """
  Representa tipo `FipePossivel` .
  """
  @moduledoc since: "0.2.0"
  use Ecto.Schema
  import Ecto.Changeset

  alias ExDatacube.Veiculos.Veiculo
  alias ExDatacube.Veiculos.Veiculo.Ano

  @type t :: %__MODULE__{
          referencia: String.t(),
          ano: Veiculo.ano(),
          ano_modelo: Veiculo.ano(),
          tipo_veiculo: String.t(),
          marca: String.t(),
          modelo: String.t(),
          combustivel: String.t(),
          valor: String.t()
        }

  @primary_key false
  @derive [Jason.Encoder]
  embedded_schema do
    field :referencia, :string
    field :ano, Ano
    field :ano_modelo, Ano
    field :tipo_veiculo, :string
    field :marca, :string
    field :modelo, :string
    field :combustivel, :string
    field :valor, :decimal
  end

  def changeset(struct, params) do
    struct
    |> cast(params, __schema__(:fields) -- __schema__(:embeds),
      empty_values: Veiculo.empty_values()
    )
  end
end

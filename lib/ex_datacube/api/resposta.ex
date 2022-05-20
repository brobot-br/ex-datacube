defmodule ExDatacube.API.Resposta do
  @moduledoc """
  Resposta padrão de retorno da API consultasdeveiculos
  """
  @moduledoc since: "0.2.0"

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  Indica o status da requisição. Se `status` for `false`, houve algum erro na requisição
  e neste caso detalhes podem ser acessados na variável `msg`.
  """
  @type status :: boolean()

  @typedoc """
  Mensagem de erro da API consultadeveiculos quando status: `false`
  """
  @type error_message :: String.t()

  @type t :: %__MODULE__{
          status: boolean(),
          result: map(),
          paid: boolean(),
          msg: error_message(),
          code: pos_integer(),
          request_uid: String.t()
        }

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do
    field :status, :boolean
    field :result, :map
    field :paid, :boolean
    field :msg, :string
    field :code, :integer
    field :request_uid, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, __schema__(:fields))
  end

  def new(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:insert)
  end
end

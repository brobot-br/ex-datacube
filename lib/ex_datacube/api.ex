defmodule ExDatacube.API do
  @moduledoc """
  Módulo de comunicação com a API da Datacube.
  """
  @moduledoc since: "0.1.1"

  alias ExDatacube.DatacubeFinch
  alias ExDatacube.API.Resposta

  @typedoc """
  Função de codificação dos parâmetros para x-www-form-urlencoded. Default `URI.encode_query/1`
  """
  @type encode :: (map -> binary)

  @typedoc """
  Função de decodificação dos retornos da API. Default `Jason.decode!/1`
  """
  @type decode :: (binary -> map)

  @typedoc """
  Se token de autenticação à API for fornecido nas opções, ele será incluído
  no body da requisição caso um token não exista no mapa de parâmetros fornecido.
  """
  @type auth_token :: String.t()
  @type opts :: [
          {:encode, encode},
          {:decode, decode},
          {:auth_token, auth_token},
          {:receive_timeout, pos_integer()}
        ]

  @typedoc """
  Erros de network (provenientes do Finch).
  """
  @type exception_error :: {:error, Exception.t()}

  @typedoc """
  Mensagems de erros dos campos fora do contrato estabelecido pela API.
  """
  @type error_message :: String.t()
  @type field :: atom()
  @type errors :: %{required(field) => [error_message()]}
  @type resposta_invalida :: {:error, {:resposta_invalida, errors}}

  @doc """
  URL base da API.
  """
  @spec base_url() :: base_urk :: String.t()
  def base_url(), do: "https://api.consultasdeveiculos.com"

  @doc """
  Concatena `path` com url base da API.
  """
  @spec url(path :: String.t()) :: url :: String.t()
  def url(path), do: "#{base_url()}/#{path}"

  @doc """
  Faz uma chamada post à API no endpoint `path`. Converte `params` para `x-www-form-urlencoded`.

  ## Exemplos
  Requisitar consulta simples de uma `placa`:

      {:ok, %Resposta{} = resposta} = ExDatacube.API.post(
        "veiculos/informacao-simples",
        %{placa: "FLT9034"},
        auth_token: "XXX"
      )
  """
  @spec post(path :: String.t(), body :: map | String.t(), opts) ::
          {:ok, Resposta.t()} | exception_error | resposta_invalida
  def post(path, %{} = params, opts \\ []) do
    with {:ok, response} <- do_post(path, params, opts),
         body = decode_body(response.body, opts),
         {:error, changeset} <- Resposta.new(body) do
      errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
      {:error, {:resposta_invalida, errors}}
    end
  end

  defp do_post(path, params, opts) do
    url = url(path)
    headers = [{"content-type", "application/x-www-form-urlencoded"}]

    body =
      params
      |> ensure_auth_token(opts)
      |> encode_body(opts)

    :post
    |> Finch.build(url, headers, body)
    |> Finch.request(DatacubeFinch, opts)
  end

  defp ensure_auth_token(%{"auth_token" => _} = params, _opts), do: params
  defp ensure_auth_token(%{auth_token: _} = params, _opts), do: params

  defp ensure_auth_token(%{} = params, opts) do
    case Keyword.get(opts, :auth_token) do
      nil -> params
      auth_token -> Map.put(params, :auth_token, auth_token)
    end
  end

  defp encode_body(%{} = body, opts) do
    encoder = Keyword.get(opts, :encode, &URI.encode_query/1)
    encoder.(body)
  end

  defp decode_body(body, opts) when is_binary(body) do
    decoder = Keyword.get(opts, :decode, &Jason.decode!/1)
    decoder.(body)
  end
end

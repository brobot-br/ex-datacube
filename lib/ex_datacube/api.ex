defmodule ExDatacube.API do
  @moduledoc """
  Módulo de comunicação com a API da Datacube.
  """
  @moduledoc since: "0.1.1"

  alias ExDatacube.API.Resposta
  alias ExDatacube.DatacubeFinch

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
  Erros provenientes do servidor da API (tradução códigos http)
  """
  @type server_error_type ::
          :bad_request
          | :unauthorized
          | :payment_required
          | :forbidden
          | :not_found
          | :method_not_allowed
          | :too_many_requests
          | :method_failure
          | :internal_server_error
          | :service_unavailable
          | :unknown_error

  @typedoc """
  Erros resultantes na comunicação com o servidor.
  """
  @type network_error_type :: :network_error

  @type error :: {server_error_type | network_error_type, Resposta.error_message()}

  @doc """
  URL base da API.
  """
  @spec base_url() :: base_urk :: String.t()
  def base_url, do: "https://api.consultasdeveiculos.com"

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
  @spec post(path :: String.t(), body :: map | String.t(), opts) :: {:ok, Resposta.t()} | {:error, error}
  def post(path, %{} = params, opts \\ []) do
    with {:ok, response} <- do_post(path, params, opts),
         body = decode_body(response.body, opts),
         body = Map.put(body, "http_code", response.status),
         {:ok, resposta} <- Resposta.new(body) do
      parse_resposta(resposta)
    else
      {:error, %{:__exception__ => true} = exception} ->
        {:error, {:network_error, "#{inspect(exception)}"}}

      {:error, {_error_type, _error_msg}} = error ->
        error

      # resposta do servidor não está conforme tipo `Resposta` definido
      {:error, %Ecto.Changeset{} = changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn _, _, {msg, _} -> "#{msg}" end)
        {:error, {:internal_server_error, "Resposta do servidor inválida: #{inspect(errors)}"}}
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

  defp parse_resposta(%Resposta{http_code: code} = resposta) when code in 200..299 do
    {:ok, resposta}
  end

  # interpretação dos códigos feita utilizando o retorno do endpoint `/conta/erros` da API
  defp parse_resposta(%Resposta{code: code} = resposta)
       when code in [804, 805, 808, 810, 812, 813, 814, 815] do
    {:ok, resposta}
  end

  defp parse_resposta(%Resposta{http_code: 400} = r) do
    {:error, {:bad_request, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 500, code: code} = r)
       when code in [56, 70, 71, 72, 74, 76, 77, 97, 644, 654] do
    {:error, {:bad_request, r.msg}}
  end

  defp parse_resposta(%Resposta{code: code} = r) when code in [2, 26, 96, 764] do
    {:error, {:unauthorized, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 402} = r) do
    {:error, {:payment_required, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 403} = r) do
    {:error, {:forbidden, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 404} = r) do
    {:error, {:not_found, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 405} = r) do
    {:error, {:method_not_allowed, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 413, code: 818} = r) do
    {:error, {:too_many_requests, r.msg}}
  end

  # spring framework unofficial code 420 (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
  defp parse_resposta(%Resposta{http_code: 500, code: code} = r)
       when code in [19, 20, 34, 36, 699, 700, 702, 704, 766, 791, 794, 795, 796] do
    {:error, {:method_failure, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 429} = r) do
    {:error, {:too_many_requests, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 500, code: code} = r) when code in [18, 25, 11] do
    {:error, {:internal_server_error, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 401, code: 770} = r) do
    {:error, {:internal_server_error, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 500, code: 18} = r) do
    {:error, {:internal_server_error, r.msg}}
  end

  defp parse_resposta(%Resposta{http_code: 503} = r) do
    {:error, {:service_unavailable, r.msg}}
  end

  defp parse_resposta(%Resposta{} = r) do
    {:error, {:unknown_error, r.msg}}
  end
end

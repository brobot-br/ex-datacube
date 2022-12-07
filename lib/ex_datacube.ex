defmodule ExDatacube do
  @moduledoc """
  Wrapper de comunicação com à API da DataCube.

  A API da DataCube conta com três grandes seções:

    - Veículos (`ExDatacube.Veiculos`);
    - Cadastros (`ExDatacube.Cadastros`);
    - CNH (`ExDatacube.CNH`).

  Cada uma dessas seções é implementada de forma independente, de modo
  que as configurações também precisam ser fornecidas independentemente.

  ## Opções compartilhadas
    Todas as funções de comunicação com a api compartilham as opções a seguir. Além
    de passar as opções para as funções, há a opção de definí-las globalmente através da
    configuração da aplicação:

    ```
    config :ex_datacube, auth_token: "token"
    config :ex_datacube, ExDatacube.Veiculos,
        auth_token: "token",
        adaptador: ExDatacube.Veiculos.Adaptores.Default
    ```

    * `:auth_token` — token de autenticação à API, que pode ser fornecido de
    três maneiras, seguindo a seguinte precedência:
      - nas opções de qualquer chamada;
      - configuração global no contexto da api (`config :ex_datacube, API, ...`);
      - configuração global (`config :ex_datacube, ...`).

    * `:adaptador` — Adaptador a ser utilizado nas chamadas. Por padrão, o
    adaptador usado é o `ModuloAPI.Adaptores.Default` que comunica-se
    com a api de produção.
    Há disponível também o adaptador de testes `ModuloAPI.Adaptores.Stub`
    que pode ser usado por bibliotecas como a Mox para realizar
    testes.

    * `:receive_timeout` — timeout da requisição. Default: 1 minuto.
  """
  @moduledoc since: "0.1.0"

  alias ExDatacube.API
  alias ExDatacube.{Cadastros, CNH, Veiculos}
  alias ExDatacube.Veiculos.Veiculo

  @type shared_opts :: [
          {:adaptador, module()},
          {:auth_token, ExDatacube.API.auth_token()},
          {:receive_timeout, pos_integer()}
        ]

  @doc """
  Retorna resultado da busca de veículos simplificada v2.
  Nesta consulta temos informação de renavam, chassi, proprietário e
  dados cadastrais do veículo.

  ## Options
  Veja a seção ["Opções compartilhadas"](#module-opções-compartilhadas) na
  documentação do módulo para as opções possíveis.

  ## Exemplo

      {:ok, %Veiculo{} = veiculo} =
        ExDatacube.consulta_nacional_simples_v2("FLT9034")

  """
  @doc group: "API Veículos"
  @doc since: "0.2.0"
  @spec consulta_nacional_simples_v2(Veiculos.placa(), shared_opts()) ::
          {:ok, Veiculo.t()} | {:error, API.error()}
  def consulta_nacional_simples_v2(placa, opts \\ []) do
    {adaptador, opts} =
      opts
      |> merge_config(Veiculos)
      |> Keyword.pop(:adaptador, Module.concat(Veiculos, Adaptadores.Default))

    adaptador.consulta_nacional_simples_v2(placa, opts)
  end

  @doc """
  Retorna resultado da busca de veículos simplificada v3.
  Nesta consulta temos informação de renavam, chassi e dados cadastrais do veículo.

  *Não há informação de proprietário nesta consulta*

  ## Options
  Veja a seção ["Opções compartilhadas"](#module-opções-compartilhadas) na
  documentação do módulo para as opções possíveis.

  ## Exemplo

      {:ok, %Veiculo{} = veiculo} =
        ExDatacube.consulta_nacional_simples_v3("FLT9034")

  """
  @doc group: "API Veículos"
  @doc since: "0.4.0"
  @spec consulta_nacional_simples_v3(Veiculos.placa(), shared_opts()) ::
          {:ok, Veiculo.t()} | {:error, API.error()}
  def consulta_nacional_simples_v3(placa, opts \\ []) do
    {adaptador, opts} =
      opts
      |> merge_config(Veiculos)
      |> Keyword.pop(:adaptador, Module.concat(Veiculos, Adaptadores.Default))

    adaptador.consulta_nacional_simples_v3(placa, opts)
  end

  @doc """
  Retorna resultado da busca de veículos completa.

  ## Options
  Veja a seção ["Opções compartilhadas"](#module-opções-compartilhadas) na
  documentação do módulo para as opções possíveis.

  ## Exemplo

      {:ok, %ExDataCube.Veiculos.Veiculo{} = veiculo} =
        ExDatacube.consulta_nacional_completa("FLT9034")

  """
  @spec consulta_nacional_completa(Veiculos.placa(), shared_opts()) ::
          {:ok, Veiculo.t()} | {:error, API.error()}
  @doc group: "API Veículos"
  @doc since: "0.2.0"
  def consulta_nacional_completa(placa, opts \\ []) do
    {adaptador, opts} =
      opts
      |> merge_config(Veiculos)
      |> Keyword.pop(:adaptador, Module.concat(Veiculos, Adaptadores.Default))

    adaptador.consulta_nacional_completa(placa, opts)
  end

  @doc """
  Retorna resultado da busca de veículos no endpoint agregados.

  Este endpoint retorna as mesmas informações da simples v3 (praticamente)
  mas não possui abrangência para toda base de veículos. **Logo, há certas
  consultas que não retornaram a informação de renavam.**

  ## Options
  Veja a seção ["Opções compartilhadas"](#module-opções-compartilhadas) na
  documentação do módulo para as opções possíveis.

  ## Exemplo

      {:ok, %ExDataCube.Veiculos.Veiculo{} = veiculo} =
        ExDatacube.consulta_nacional_agregados("FLT9034")

  """
  @spec consulta_nacional_agregados(Veiculos.placa(), shared_opts()) ::
          {:ok, Veiculo.t()} | {:error, API.error()}
  @doc group: "API Veículos"
  @doc since: "0.4.0"
  def consulta_nacional_agregados(placa, opts \\ []) do
    {adaptador, opts} =
      opts
      |> merge_config(Veiculos)
      |> Keyword.pop(:adaptador, Module.concat(Veiculos, Adaptadores.Default))

    adaptador.consulta_nacional_agregados(placa, opts)
  end

  @doc """
  Retorna CNH de motorista da base nacional.

  ## Options
  Veja a seção ["Opções compartilhadas"](#module-opções-compartilhadas) na
  documentação do módulo para as opções possíveis.

  ## Exemplo

      {:ok, map()} = ExDatacube.consulta_nacional_cnh("348.666.357-67")

  """
  @spec consulta_nacional_cnh(CNH.cpf(), shared_opts()) ::
          {:ok, map()} | {:error, API.error()}
  @doc group: "API CNH"
  @doc since: "0.2.0"
  def consulta_nacional_cnh(cpf, opts \\ []) do
    {adaptador, opts} =
      opts
      |> merge_config(CNH)
      |> Keyword.pop(:adaptador, Module.concat(CNH, Adaptadores.Default))

    if adaptador do
      adaptador.consulta_nacional_cnh(cpf, opts)
    else
      raise "Adaptador da consulta ainda não implementado."
    end
  end

  @doc """
  Retorna dados da empresa identificada pelo `cnpj`.

  ## Options
  Veja a seção ["Opções compartilhadas"](#module-opções-compartilhadas) na
  documentação do módulo para as opções possíveis.

  ## Exemplo

      {:ok, map()} = ExDatacube.consulta_dados_cnpj("47.960.950/0001-21")

  """
  @spec consulta_dados_cnpj(Cadastros.cnpj(), shared_opts()) ::
          {:ok, map()} | {:error, API.error()}
  @doc group: "API Cadastros"
  @doc since: "0.2.0"
  def consulta_dados_cnpj(cnpj, opts \\ []) do
    {adaptador, opts} =
      opts
      |> merge_config(Cadastros)
      |> Keyword.pop(:adaptador, Module.concat(Cadastros, Adaptadores.Default))

    if adaptador do
      adaptador.consulta_dados_cnpj(cnpj, opts)
    else
      raise "Adaptador da consulta ainda não implementado."
    end
  end

  # Private helpers
  defp merge_config(opts, api_behaviour) do
    auth_token = Application.get_env(:ex_datacube, :auth_token)

    env_opts =
      Application.get_env(:ex_datacube, api_behaviour, [])
      |> Keyword.update(:auth_token, auth_token, & &1)

    Keyword.merge(env_opts, opts)
  end
end

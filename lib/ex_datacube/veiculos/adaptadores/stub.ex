defmodule ExDatacube.Veiculos.Adaptores.Stub do
  @moduledoc """
  Implementa um stub para o behaviour da api de veículos
  retornando dados dummy.
  """
  @moduledoc since: "0.2.0"

  alias ExDatacube.Veiculos
  alias ExDatacube.Veiculos.Veiculo

  @behaviour Veiculos

  @doc false
  @impl Veiculos
  def consulta_nacional_simples_v2(placa, _opts) do
    {:ok, veiculo(placa)}
  end

  @doc false
  @impl Veiculos
  def consulta_nacional_simples_v3(placa, _opts) do
    {:ok, veiculo_simples(placa)}
  end

  @doc false
  @impl Veiculos
  def consulta_nacional_completa(placa, _opts) do
    {:ok, veiculo(placa)}
  end

  @doc false
  @impl Veiculos
  def consulta_nacional_agregados(placa, _opts) do
    {:ok, veiculo_simples(placa)}
  end

  defp veiculo(placa) do
    %Veiculo{
      ano_fabricacao: "2014",
      ano_modelo: "2014",
      capacidade_carga: nil,
      categoria: nil,
      chassi: "9BFZEANE8EBS61008",
      cilindradas: nil,
      cmt: nil,
      combustivel: "DIESEL",
      cor: nil,
      data_ultimo_licenciamento: nil,
      eixos: nil,
      exercicio_ultimo_licenciamento: nil,
      comunicado_venda: %Veiculo.ComunicadoVenda{
        data_inclusao: nil,
        data_venda: nil,
        documento: nil,
        nota_fiscal: nil,
        protocolo_detran: nil,
        situacao: "Não Consta Comunicação de Vendas",
        tipo_comprador: nil
      },
      fipe_possivel: [
        %Veiculo.FipePossivel{
          ano: "2014",
          ano_modelo: "2014",
          combustivel: "Diesel",
          marca: "FORD",
          modelo: "CARGO 2629 E 6x4 Turbo 2p (diesel)(E5)",
          referencia: "2022-05",
          tipo_veiculo: "caminhao",
          valor: Decimal.new("214844.00")
        }
      ],
      gravames: nil,
      importado: false,
      intencao_gravame: nil,
      marca: "FORD",
      modelo: "CARGO 2629 6X4",
      municipio: "CAMPINAS",
      placa: placa,
      potencia: nil,
      proprietario: nil,
      proprietario_anterior: nil,
      proprietario_documento: "01637895000132",
      renavam: "01001794033",
      restricoes: nil,
      tipo: nil,
      uf: "SP"
    }
  end

  defp veiculo_simples(placa) do
    %Veiculo{
      chassi: "9BFZEANE8EBS61008",
      placa: placa,
      marca: "TROLLER",
      modelo: "T4 TDI 3.0",
      cor: "VERMELHA",
      ano_fabricacao: "2010",
      ano_modelo: "2011",
      renavam: "01001794033",
      uf: "SP",
      municipio: "CAMPINAS",
      importado: false,
      proprietario: nil,
      proprietario_documento: nil,
      proprietario_anterior: nil,
      capacidade_carga: nil,
      categoria: nil,
      cilindradas: nil,
      eixos: nil,
      cmt: nil,
      combustivel: nil,
      potencia: nil,
      tipo: nil,
      data_ultimo_licenciamento: nil,
      exercicio_ultimo_licenciamento: nil,
      gravames: nil,
      intencao_gravame: nil,
      restricoes: nil,
      fipe_possivel: [
        %Veiculo.FipePossivel{
          ano: "2014",
          ano_modelo: "2014",
          combustivel: "Diesel",
          marca: "FORD",
          modelo: "CARGO 2629 E 6x4 Turbo 2p (diesel)(E5)",
          referencia: "2022-05",
          tipo_veiculo: "caminhao",
          valor: Decimal.new("214844.00")
        }
      ]
    }
  end
end

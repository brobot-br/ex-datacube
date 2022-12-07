defmodule ExDatacube.MixProject do
  @moduledoc false

  use Mix.Project

  @name "ExDatacube"
  @version "0.4.0"
  @repo_url "https://github.com/brobot-br/ex-datacube"

  def project do
    [
      app: :ex_datacube,
      version: @version,
      elixir: "~> 1.13",
      description: "Cliente API DataCube",
      package: package(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      name: @name,
      source_url: @repo_url,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs",
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        flags: [:error_handling, :unknown],
        # Error out when an ignore rule is no longer useful so we can remove it
        list_unused_filters: true,
        plt_add_apps: [:jason]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support/test_usage.ex"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExDatacube.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.12"},
      {:ecto, "~> 3.8"},

      ## Dev tools
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url},
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*)
    ]
  end

  def docs do
    [
      logo: "assets/datacube.png",
      source_ref: "v#{@version}",
      source_url: @repo_url,
      main: @name,
      extra_section: "CHANGELOG",
      extras: extras(),
      groups_for_functions: [
        group_for_function("API Veículos"),
        group_for_function("API CNH"),
        group_for_function("API Cadastros")
      ],
      groups_for_modules: [
        APIs: [
          ExDatacube.Veiculos,
          ExDatacube.CNH,
          ExDatacube.Cadastros
        ],
        "Tipos Veículos": [
          ExDatacube.Veiculos.Veiculo,
          ExDatacube.Veiculos.Veiculo.UF,
          ExDatacube.Veiculos.Veiculo.Renavam,
          ExDatacube.Veiculos.Veiculo.ComunicadoVenda,
          ExDatacube.Veiculos.Veiculo.FipePossivel,
          ExDatacube.Veiculos.Veiculo.Gravame
        ],
        "Adaptadores Veículos": [
          ExDatacube.Veiculos.Adaptores.Default,
          ExDatacube.Veiculos.Adaptores.Stub
        ],
        "API Genérica": [
          ExDatacube.API
        ],
        "Tipos Genérica": [
          ExDatacube.API.Resposta
        ]
      ]
    ]
  end

  defp group_for_function(group), do: {String.to_atom(group), &(&1[:group] == group)}

  defp extras do
    [
      "CHANGELOG.md"
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      check: [
        "clean",
        "deps.unlock --check-unused",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "deps.unlock --check-unused",
        "test --warnings-as-errors",
        "credo"
      ]
    ]
  end
end

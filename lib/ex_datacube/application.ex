defmodule ExDatacube.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # pool to access vehicle api
      {Finch,
       name: ExDatacube.DatacubeFinch,
       pools: %{
         :default => [size: 2],
         "https://api.consultasdeveiculos.com" => [size: 10]
       }}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExDatacube.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

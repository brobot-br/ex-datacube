# ExDatacube

**Elixir wrapper for DataCube api**

## Installation

Full documentation can be found at <https://hexdocs.pm/ex_datacube>.

The package can be installed by adding `ex_datacube` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_datacube, "~> 0.3.2"}
  ]
end
```
and your `auth_token` can be provided by adding this to your `config.exs`:
```elixir
config :ex_datacube, auth_token: "token"
```
For other ways to  configure the library, please check the [docs](https://hexdocs.pm/ex_datacube).

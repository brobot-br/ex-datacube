defmodule ExDatacube do
  @moduledoc """
  Documentation for `ExDatacube`.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Hello world.

  ## Options

  These options are required; without them the supervisor won't start

  * `:repo` — specifies the Ecto repo used to insert and retrieve jobs

  ## Examples

      iex> ExDatacube.hello()
      :world

  """
  @doc since: "0.1.0"
  @spec hello() :: :world
  def hello do
    :world
  end
end

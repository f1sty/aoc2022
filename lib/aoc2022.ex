defmodule Aoc2022 do
  @moduledoc """
  Module for common used functions.
  """

  @puzzles_subdir "priv/puzzle_inputs"

  def read_puzzle_input(filename) do
    @puzzles_subdir
    |> Path.absname()
    |> Path.join(filename)
    |> File.read!()
  end
end

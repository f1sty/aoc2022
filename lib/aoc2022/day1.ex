defmodule Aoc2022.Day1 do
  def part1() do
    "day1"
    |> Aoc2022.read_puzzle_input()
    |> String.split("\n\n")
    |> Enum.map(fn numbers ->
      numbers |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.sum()
    end)
    |> Enum.max()
  end
end

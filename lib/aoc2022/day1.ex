defmodule Aoc2022.Day1 do
  @moduledoc false
  def part1() do
    "day1"
    |> Aoc2022.read_puzzle_input()
    |> calories_per_elf()
    |> Enum.max()
  end

  def part2() do
    "day1"
    |> Aoc2022.read_puzzle_input()
    |> calories_per_elf()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp calories_per_elf(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn numbers ->
      numbers |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.sum()
    end)
  end
end

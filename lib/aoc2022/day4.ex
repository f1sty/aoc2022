defmodule Aoc2022.Day4 do
  def part1() do
    solving_fun = fn first_set, second_set ->
      MapSet.subset?(first_set, second_set) or MapSet.subset?(second_set, first_set)
    end

    solve(solving_fun)
  end

  def part2() do
    solving_fun = fn first_set, second_set ->
      MapSet.intersection(first_set, second_set) |> MapSet.size() |> Kernel.!=(0)
    end

    solve(solving_fun)
  end

  defp solve(solving_fun) do
    "day4"
    |> Aoc2022.read_puzzle_input()
    |> String.split()
    |> Enum.reduce(0, fn assignment_pair, acc ->
      [first_set, second_set] =
        assignment_pair
        |> String.replace("-", "..")
        |> String.split(",")
        |> Enum.map(fn range -> range |> Code.eval_string() |> elem(0) |> MapSet.new() end)

      if solving_fun.(first_set, second_set) do
        acc + 1
      else
        acc
      end
    end)
  end
end

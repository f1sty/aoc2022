defmodule Aoc2022.Day3 do
  def part1() do
    priority_map = priority_map()

    "day3"
    |> Aoc2022.read_puzzle_input()
    |> String.split()
    |> Enum.reduce(0, fn rucksack_items, priorities_sum ->
      compartment_size = round(String.length(rucksack_items) / 2)

      common_item =
        rucksack_items
        |> String.split_at(compartment_size)
        |> then(fn {c1, c2} -> String.myers_difference(c1, c2) |> Keyword.get(:eq) end)

      priorities_sum + priority_map[common_item]
    end)
  end

  def part2() do
    priority_map = priority_map()

    "day3"
    |> Aoc2022.read_puzzle_input()
    |> String.split()
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, fn rucksacks_chunk, priorities_sum ->
      [first, second, third] =
        Enum.map(rucksacks_chunk, fn items ->
          items
          |> String.graphemes()
          |> MapSet.new()
        end)

      [common_item] =
        first
        |> MapSet.intersection(second)
        |> MapSet.intersection(third)
        |> MapSet.to_list()

      priorities_sum + priority_map[common_item]
    end)
  end

  defp priority_map() do
    letters = Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z)

    letters
    |> to_string()
    |> String.graphemes()
    |> Enum.zip(1..52)
    |> Map.new()
  end
end

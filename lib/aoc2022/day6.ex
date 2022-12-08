defmodule Aoc2022.Day6 do
  @sizes %{sop: 4, som: 14}

  def part1() do
    "day6"
    |> Aoc2022.read_puzzle_input()
    |> parse_input()
    |> process_signal(:sop)
  end

  def part2() do
    "day6"
    |> Aoc2022.read_puzzle_input()
    |> parse_input()
    |> process_signal(:som)
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
  end

  defp process_signal(signal_stream, mode) do
    signal_stream
    |> Enum.chunk_every(@sizes[mode], 1, :discard)
    |> Enum.reduce_while(0, fn window, position ->
      if window |> Enum.uniq() |> Enum.count() == @sizes[mode] do
        {:halt, position + @sizes[mode]}
      else
        {:cont, position + 1}
      end
    end)
  end
end

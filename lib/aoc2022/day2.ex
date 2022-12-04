defmodule Aoc2022.Day2 do
  @win_combinations Enum.zip(1..3, [2, 3, 1])
  @lose_combinations Enum.zip(1..3, [3, 1, 2])

  def part1() do
    # first column: A - Rock, B - Paper, C - Scissors
    # second column: X - Rock, Y - Paper, Z - Scissors
    # score:
    # for shape (1, 2, 3) + for outcome (0, 3, 6)

    "day2"
    |> Aoc2022.read_puzzle_input()
    |> format_input()
    |> part1_get_total_score(0)
  end

  def part2() do
    # first column: A - Rock, B - Paper, C - Scissors
    # second column: X - Lose, Y - Draw, Z - Win
    # score:
    # for shape (1, 2, 3) + for outcome (0, 3, 6)

    "day2"
    |> Aoc2022.read_puzzle_input()
    |> format_input()
    |> part2_get_total_score(0)
  end

  defp format_input(input) do
    input
    |> String.split()
    |> Enum.map(fn shape ->
      cond do
        shape in ~w[A X] -> 1
        shape in ~w[B Y] -> 2
        shape in ~w[C Z] -> 3
        true -> raise("Corrupted input")
      end
    end)
  end

  defp part1_get_total_score([opponent_shape, your_shape | rest], total_score)
       when {opponent_shape, your_shape} in @win_combinations do
    score = your_shape + 6
    part1_get_total_score(rest, total_score + score)
  end

  defp part1_get_total_score([opponent_shape, your_shape | rest], total_score)
       when opponent_shape == your_shape do
    score = your_shape + 3
    part1_get_total_score(rest, total_score + score)
  end

  defp part1_get_total_score([_opponent_shape, your_shape | rest], total_score) do
    score = your_shape
    part1_get_total_score(rest, total_score + score)
  end

  defp part1_get_total_score([], total_score) do
    total_score
  end

  defp part2_get_total_score([opponent_shape, 3 | rest], total_score) do
    your_shape =
      @win_combinations
      |> Enum.find(&(elem(&1, 0) == opponent_shape))
      |> elem(1)

    score = your_shape + 6
    part2_get_total_score(rest, total_score + score)
  end

  defp part2_get_total_score([opponent_shape, 2 | rest], total_score) do
    your_shape = opponent_shape
    score = your_shape + 3
    part2_get_total_score(rest, total_score + score)
  end

  defp part2_get_total_score([opponent_shape, 1 | rest], total_score) do
    your_shape =
      @lose_combinations
      |> Enum.find(&(elem(&1, 0) == opponent_shape))
      |> elem(1)

    score = your_shape
    part2_get_total_score(rest, total_score + score)
  end

  defp part2_get_total_score([], total_score) do
    total_score
  end
end

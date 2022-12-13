defmodule Aoc2022.Day9 do
  @moduledoc false

  @knotes 9

  @type coordinates :: {integer(), integer()}

  def part1() do
    "day9"
    |> Aoc2022.read_puzzle_input()
    |> input_to_motions()
    |> motions_to_coordinates_list()
    |> tails_coordinates_list()
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2() do
    "day9"
    |> Aoc2022.read_puzzle_input()
    |> input_to_motions()
    |> motions_to_coordinates_list()
    |> then(
      &Enum.reduce(1..@knotes, &1, fn _tail_nummber, tail_coordinates_list ->
        tails_coordinates_list(tail_coordinates_list)
      end)
    )
    |> Enum.uniq()
    |> Enum.count()
  end

  @spec input_to_motions(String.t()) :: list()
  def input_to_motions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn instruction, instructions ->
      case instruction do
        "R " <> steps -> List.duplicate(:right, String.to_integer(steps)) ++ instructions
        "L " <> steps -> List.duplicate(:left, String.to_integer(steps)) ++ instructions
        "U " <> steps -> List.duplicate(:up, String.to_integer(steps)) ++ instructions
        "D " <> steps -> List.duplicate(:down, String.to_integer(steps)) ++ instructions
      end
    end)
    |> Enum.reverse()
  end

  @spec motions_to_coordinates_list(list()) :: [coordinates()]
  def motions_to_coordinates_list(motions) do
    motions_to_coordinates_list(motions, {0, 0}, [])
  end

  @spec motions_to_coordinates_list(list(), coordinates(), [coordinates()]) :: [coordinates()]
  def motions_to_coordinates_list([], _coordinates, coordinates_list),
    do: Enum.reverse(coordinates_list)

  def motions_to_coordinates_list([direction | motions], {x, y}, coordinates_list) do
    coordinates =
      case direction do
        :right -> {x + 1, y}
        :left -> {x - 1, y}
        :up -> {x, y + 1}
        :down -> {x, y - 1}
      end

    motions_to_coordinates_list(motions, coordinates, [coordinates | coordinates_list])
  end

  @spec tails_coordinates_list([coordinates()]) :: [coordinates()]
  def tails_coordinates_list(coordinates_list) do
    tails_coordinates_list(coordinates_list, {0, 0}, [])
  end

  @spec tails_coordinates_list([coordinates()], coordinates(), [coordinates()]) :: [coordinates()]
  def tails_coordinates_list([], _tail_coordinates, tail_coordinates_list),
    do: Enum.reverse(tail_coordinates_list)

  def tails_coordinates_list([head_pos | head_coordinates_list], tail_pos, tail_coordinates_list) do
    tail_pos = maybe_move_tail(tail_pos, head_pos)
    tail_coordinates_list = [tail_pos | tail_coordinates_list]

    tails_coordinates_list(head_coordinates_list, tail_pos, tail_coordinates_list)
  end

  defp maybe_move_tail({x1, y1}, {x2, y2}) do
    adjacent = for x <- (x1 - 1)..(x1 + 1), y <- (y1 - 1)..(y1 + 1), do: {x, y}

    if {x2, y2} in adjacent do
      {x1, y1}
    else
      cond do
        y1 == y2 and x1 < x2 -> {x1 + 1, y1}
        y1 == y2 and x1 > x2 -> {x1 - 1, y1}
        x1 == x2 and y1 < y2 -> {x1, y1 + 1}
        x1 == x2 and y1 > y2 -> {x1, y1 - 1}
        y1 < y2 and x1 < x2 -> {x1 + 1, y1 + 1}
        y1 > y2 and x1 > x2 -> {x1 - 1, y1 - 1}
        y1 < y2 and x1 > x2 -> {x1 - 1, y1 + 1}
        y1 > y2 and x1 < x2 -> {x1 + 1, y1 - 1}
      end
    end
  end
end

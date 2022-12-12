defmodule Aoc2022.Day9 do
  @moduledoc false

  def part1() do
    "day9"
    |> Aoc2022.read_puzzle_input()
    |> parse()
    |> Enum.count()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> simulate()
  end

  def simulate(head_moves) do
    head_moves
    |> Enum.reduce({{0, 0}, :queue.new()}, fn instruction, {head_pos, head_route} ->
      [direction, steps] = String.split(instruction, " ", trim: true)
      steps = String.to_integer(steps)
      head_route = move_head(direction, steps, head_pos, head_route)
      head_pos = :queue.last(head_route)

      {head_pos, head_route}
    end)
    |> move_tail({0, 0}, %{})
  end

  def move_head("R", steps, {x, y}, route),
    do: Enum.reduce((x + 1)..(x + steps), route, fn dx, route -> :queue.in({dx, y}, route) end)

  def move_head("L", steps, {x, y}, route),
    do: Enum.reduce((x - 1)..(x - steps), route, fn dx, route -> :queue.in({dx, y}, route) end)

  def move_head("U", steps, {x, y}, route),
    do: Enum.reduce((y + 1)..(y + steps), route, fn dy, route -> :queue.in({x, dy}, route) end)

  def move_head("D", steps, {x, y}, route),
    do: Enum.reduce((y - 1)..(y - steps), route, fn dy, route -> :queue.in({x, dy}, route) end)

  def move_tail({_, head_route}, tail_pos, tail_route) do
    case :queue.out(head_route) do
      {{:value, head_pos}, head_route} ->
        tail_pos = maybe_move_tail(tail_pos, head_pos)
        tail_route = Map.update(tail_route, tail_pos, 1, &(&1 + 1))
        move_tail({head_pos, head_route}, tail_pos, tail_route)

      {:empty, _} ->
        tail_route
    end
  end

  def maybe_move_tail({x1, y1}, {x2, y2}) do
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

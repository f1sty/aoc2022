defmodule Aoc2022.Day12 do
  def part1() do
    "day12"
    |> Aoc2022.read_puzzle_input()
    |> parse()
    |> make_moves(40, nil)
  end

  def parse(input) do
    input = String.split(input, "\n", trim: true)

    heightmap =
      for line <- input do
        for <<elevation <- line>> do
          elevation - ?a
        end
      end
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        line
        |> Enum.reduce({0, %{}}, fn height, {x, line_of_map} ->
          {x + 1, Map.put(line_of_map, {x, y}, height)}
        end)
        |> elem(1)
        |> Map.merge(acc)
      end)

    {start_point, _} = Enum.find(heightmap, fn {_, height} -> height == ?S - ?a end)
    {end_point, _} = Enum.find(heightmap, fn {_, height} -> height == ?E - ?a end)

    heightmap =
      heightmap
      |> Map.put(start_point, 0)
      |> Map.put(end_point, ?z - ?a)

    %{start_point: start_point, end_point: end_point, map: heightmap}
  end

  def make_moves(%{start_point: start_point, end_point: end_point, map: map}, times, last_point) do
    make_moves(map, {start_point, nil, []}, end_point, [], times, last_point)
  end

  def make_moves(_map, {current_point, _, _}, end_point, moves, _, _last_point)
      when current_point == end_point do
    Enum.reverse(moves)
  end

  def make_moves(map, {{x, y}, _, _} = current_point, end_point, moves, times, last_point) do
    current_height = Map.get(map, {x, y})
    IO.inspect(current_point, label: "current_point")
    candidates = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}] -- [last_point]

    candidate_points =
      map
      |> Map.take(candidates)
      |> Map.filter(fn {_, height} -> not (height > current_height + 1) end)
      |> with_weigts(end_point)
      |> Enum.sort_by(fn {_, distance} -> distance end)

    case candidate_points == [] do
      true ->
        [new_point | moves] = moves
        make_moves(map, Tuple.append(new_point, []), end_point, moves, times - 1, {x, y})

      false ->
        new_point = hd(candidate_points)
        make_moves(map, Tuple.append(new_point, candidate_points), end_point, [new_point | moves], times - 1, {x, y})
    end
  end

  def with_weigts(points, {a, b} = _end_point) do
    Enum.map(points, fn {{x, y}, _} ->
      distance = :math.sqrt((a - x) ** 2 + (b - y) ** 2)
      {{x, y}, distance}
    end)
  end
end


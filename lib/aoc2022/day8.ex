defmodule Aoc2022.Day8 do
  def part1() do
    "day8"
    |> Aoc2022.read_puzzle_input()
    |> parse()
    |> scan_forest(&tallest?/5)
    |> then(fn {edge_trees_qty, trees} ->
      Enum.count(trees, fn visible -> visible end) + edge_trees_qty
    end)
  end

  def part2() do
    "day8"
    |> Aoc2022.read_puzzle_input()
    |> parse()
    |> scan_forest(&scenic_scores/5)
    |> elem(1)
    |> Enum.max()
  end

  defp parse(input) do
    rows =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      end)

    columns =
      rows
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    {rows, columns}
  end

  defp scan_forest({rows, columns}, fun) do
    [width, height] = Enum.map([rows, columns], &(hd(&1) |> length()))
    edge_trees_qty = 2 * (width + height) - 4

    ret =
      for y <- 1..(height - 2), x <- 1..(width - 2) do
        tree_height = columns |> Enum.at(x) |> Enum.at(y)

        {left, [_ | right]} = rows |> Enum.at(y) |> Enum.split(x)
        {up, [_ | down]} = columns |> Enum.at(x) |> Enum.split(y)

        fun.(tree_height, left, right, up, down)
      end

    {edge_trees_qty, ret}
  end

  defp tallest?(height, left, right, up, down) do
    Enum.all?(left, &(&1 < height)) or Enum.all?(right, &(&1 < height)) or
      Enum.all?(up, &(&1 < height)) or Enum.all?(down, &(&1 < height))
  end

  defp scenic_scores(height, left, right, up, down) do
    left = visible_qty(left, height, :left)
    right = visible_qty(right, height, :right)
    up = visible_qty(up, height, :up)
    down = visible_qty(down, height, :down)

    left * right * up * down
  end

  defp visible_qty(trees, height, direction) do
    trees = if direction in ~w"left up"a, do: Enum.reverse(trees), else: trees

    trees
    |> Enum.find_index(&(&1 >= height))
    |> then(fn
      nil -> length(trees)
      idx -> idx + 1
    end)
  end
end

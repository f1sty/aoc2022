defmodule Aoc2022.Day5 do
  def part1() do
    {stacks, moves} = parse_input("day5")

    stacks
    |> move_crates(moves, :cm9000)
    |> crates_on_top()
  end

  def part2() do
    {stacks, moves} = parse_input("day5")

    stacks
    |> move_crates(moves, :cm9001)
    |> crates_on_top()
  end

  defp parse_input(filename) do
    [stacks, moves] =
      filename
      |> Aoc2022.read_puzzle_input()
      |> String.split("\n\n", trim: true)

    stacks =
      stacks
      |> String.split("\n")
      |> Enum.map(&to_charlist/1)
      |> Enum.zip()
      |> Enum.reject(&(elem(&1, tuple_size(&1) - 1) == ?\s))
      |> Enum.map(fn stack -> stack |> Tuple.to_list() |> :string.trim() end)

    moves =
      moves
      |> String.split("\n", trim: true)
      |> Enum.map(fn move ->
        move
        |> String.replace("\s", "")
        |> String.split(~w[move from to], trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {stacks, moves}
  end

  defp crates_on_top(stacks) do
    stacks
    |> Enum.map(&hd/1)
    |> to_string()
  end

  defp move_crates(stacks, moves, model) do
    Enum.reduce(moves, stacks, fn [crates_qty, from_stack_num, to_stack_num], acc ->
      {crates, from_stack} =
        acc
        |> Enum.at(from_stack_num - 1)
        |> Enum.split(crates_qty)

      crates =
        case model do
          :cm9000 -> Enum.reverse(crates)
          :cm9001 -> crates
          _ -> raise("wrong CrateMover model!")
        end

      to_stack = crates ++ Enum.at(acc, to_stack_num - 1)

      acc
      |> List.replace_at(from_stack_num - 1, from_stack)
      |> List.replace_at(to_stack_num - 1, to_stack)
    end)
  end
end

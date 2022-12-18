defmodule Aoc2022.Day11 do

  @most_active_qty 2
  @rounds 20

  def part1() do
    "day11"
    |> Aoc2022.read_puzzle_input()
    |> parse()
    |> run_rounds(@rounds)
    |> monkey_business_level(@most_active_qty)
  end

  def run_rounds(monkeys, rounds) do
    monkeys_qty = length(monkeys) * rounds

    Enum.reduce(1..monkeys_qty, monkeys, fn _monkey, updated_monkeys ->
      process_items(updated_monkeys)
    end)
  end

  def process_items([
        %{inspected: inspected, items: items, operation: operation, test: test} = monkey | monkeys
      ]) do
    {inspected, monkeys} =
      Enum.reduce(items, {inspected, monkeys}, fn item, {inspected, acc} ->
        worry_level = inspect_item(item, operation)
        monkey_idx = Enum.find_index(acc, &(&1.monkey_id == test.(worry_level)))

        updated_monkey =
          acc
          |> Enum.at(monkey_idx)
          |> then(fn m -> %{m | items: m.items ++ [worry_level]} end)

        {inspected + 1, List.replace_at(acc, monkey_idx, updated_monkey)}
      end)

    monkeys ++ [%{monkey | items: [], inspected: inspected}]
  end

  def inspect_item(item, operation) do
    {worry_level, _} = operation |> String.replace("old", to_string(item)) |> Code.eval_string()
    div(worry_level, 3)
  end

  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn monkey ->
      [_, monkey_id] = Regex.run(~r/Monkey ([[:digit:]].*):/, monkey)
      [_, items] = Regex.run(~r/Starting items: ([[:digit:]].*)/, monkey)
      [_, operation] = Regex.run(~r/= (.*)/, monkey)
      [_, divisor] = Regex.run(~r/by ([[:digit:]].*)/, monkey)
      [_, if_true] = Regex.run(~r/true.*monkey (.*)/, monkey)
      [_, if_false] = Regex.run(~r/false.*monkey (.*)/, monkey)

      items = String.split(items, [",", " "], trim: true) |> Enum.map(&String.to_integer/1)
      divisor = String.to_integer(divisor)

      %{
        monkey_id: monkey_id,
        inspected: 0,
        items: items,
        operation: operation,
        test: fn x -> if rem(x, divisor) == 0, do: if_true, else: if_false end
      }
    end)
  end

  def monkey_business_level(monkeys, most_active_qty) do
    monkeys
    |> Enum.sort_by(& &1.inspected, :desc)
    |> Enum.take(most_active_qty)
    |> Enum.map(& &1.inspected)
    |> Enum.product()
  end
end

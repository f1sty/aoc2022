defmodule Aoc2022.Day10 do
  @moduledoc false

  @type command :: {atom(), nil | integer(), pos_integer()}
  @type cpu_state :: {non_neg_integer(), {atom(), nil | integer()}, integer()}

  @initial_state {0, 1}
  @seek 19
  @step 40
  @qty 6

  def part1() do
    "day10"
    |> Aoc2022.read_puzzle_input()
    |> to_commands()
    |> execute()
    |> Enum.split(@seek)
    |> elem(1)
    |> Enum.take_every(@step)
    |> Enum.take(@qty)
    |> Enum.map(&signal_strength/1)
    |> Enum.sum()
  end

  def part2() do
    "day10"
    |> Aoc2022.read_puzzle_input()
    |> to_commands()
    |> execute()
    |> draw()
  end

  @spec to_commands(String.t()) :: [command]
  def to_commands(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "noop" -> {:noop, nil, 1}
      "addx " <> number -> {:addx, String.to_integer(number), 2}
    end)
  end

  @spec draw([cpu_state]) :: :ok
  def draw(cpu_states) do
    cpu_states
    |> Enum.map(fn {cycle, _opcode, x} ->
      crt_position = rem(cycle - 1, @step)
      sprite_pixels = (x - 1)..(x + 1)

      case crt_position in sprite_pixels do
        true -> ?#
        false -> ?.
      end
    end)
    |> Enum.chunk_every(40)
    |> Enum.intersperse('\n')
    |> Enum.join()
    |> IO.puts()
  end

  @spec execute([command]) :: [cpu_state]
  def execute(commands), do: execute(commands, @initial_state, [])

  defp execute([], _pivot, cpu_states), do: Enum.reverse(cpu_states)

  defp execute([command | commands], pivot, cpu_states) do
    {new_cpu_states, cycle, x} = cycle_through(command, pivot)
    execute(commands, {cycle, x}, new_cpu_states ++ cpu_states)
  end

  defp cycle_through({opcode, arg, cycles}, {cycle, x}) do
    cpu_states = Enum.map(1..cycles, fn diff -> {cycle + diff, {opcode, arg}, x} end)

    next_x =
      case opcode do
        :noop -> x
        :addx -> x + arg
      end

    {Enum.reverse(cpu_states), cycle + cycles, next_x}
  end

  defp signal_strength({cycle, _command, x}), do: cycle * x
end

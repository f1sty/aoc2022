defmodule Aoc2022.Day1Test do
  use ExUnit.Case
  alias Aoc2022.Day1

  test "solving part 1" do
    assert Day1.part1() == 71023
  end

  test "solving part 2" do
    assert Day1.part2() == 206_289
  end
end

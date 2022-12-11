defmodule Aoc2022.Day8Test do
  use ExUnit.Case
  alias Aoc2022.Day8

  test "solving part 1" do
    assert Day8.part1() == 1801
  end

  test "solving part 2" do
    assert Day8.part2() == 209_880
  end
end

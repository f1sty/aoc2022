defmodule Aoc2022Day9Test do
  use ExUnit.Case, async: true
  alias Aoc2022.Day9

  test "solving part 1" do
    assert Day9.part1() == 6037
  end

  test "solving part 2" do
    assert Day9.part2() == 2485
  end
end

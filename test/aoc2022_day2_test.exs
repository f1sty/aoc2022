defmodule Aoc2022.Day2Test do
  use ExUnit.Case
  alias Aoc2022.Day2

  test "solving part 1" do
    assert Day2.part1() == 11_873
  end

  test "solving part 2" do
    assert Day2.part2() == 12_014
  end
end

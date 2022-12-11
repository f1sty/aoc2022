defmodule Dir do
  defstruct files: [], dirs: []
end

defmodule Aoc2022.Day7 do
  @total_space 70_000_000
  @space_needed 30_000_000

  def part1() do
    "day7_ex"
    |> Aoc2022.read_puzzle_input()
    |> String.split("\n", trim: true)
    |> process_input()
    |> then(&Enum.map(&1, fn {path, dir} -> {path, dir_size(dir, &1, 0)} end))
    |> IO.inspect(label: "dirs")
    |> Enum.filter(fn {_path, size} -> size <= 100_000 end)
    |> Enum.reduce(0, fn {_path, size}, sum -> sum + size end)
  end

  def part2() do
    filetree =
      "day7"
      |> Aoc2022.read_puzzle_input()
      |> String.split("\n", trim: true)
      |> process_input()

    used_space = dir_size(Map.get(filetree, ["/"]), filetree, 0)
    must_be_freed = @space_needed - (@total_space - used_space)

    filetree
    |> then(&Enum.map(&1, fn {path, dir} -> {path, dir_size(dir, &1, 0)} end))
    |> Enum.sort_by(fn {_path, size} -> size end)
    |> Enum.find(fn {_path, size} -> size >= must_be_freed end)
  end

  def process_input(input) do
    process_input(input, [], %{})
  end

  def process_input([], _cwd, entries), do: entries

  def process_input(["$ " <> cmd | input], cwd, entries) do
    {input, cwd, entries} =
      case cmd do
        "ls" ->
          ls(input, cwd, entries)

        "cd " <> dir_name ->
          cwd = cd(cwd, dir_name)
          {input, cwd, entries}
      end

    process_input(input, cwd, entries)
  end

  def cd(cwd, ".."), do: tl(cwd)
  def cd(cwd, dir_name), do: [dir_name | cwd]

  def ls(input, cwd, entries) do
    {output, input} = Enum.split_while(input, fn line -> not String.starts_with?(line, "$") end)

    {files, dirs} =
      Enum.reduce(output, {[], []}, fn line, {files, dirs} ->
        case line do
          "dir " <> name ->
            dirs = [[name | cwd] | dirs]
            {files, dirs}

          file_entry ->
            [size, filename] = String.split(file_entry)
            files = [{String.to_integer(size), filename} | files]
            {files, dirs}
        end
      end)

    dir = %Dir{files: files, dirs: dirs}
    {input, cwd, Map.put_new(entries, cwd, dir)}
  end

  def dir_size(%Dir{files: files, dirs: []}, _entries, size) do
    cwd_file_sizes = Enum.reduce(files, 0, fn {fsize, _fname}, size -> size + fsize end)
    size + cwd_file_sizes
  end

  def dir_size(%Dir{files: files, dirs: dirs}, entries, _size) do
    cwd_file_sizes = Enum.reduce(files, 0, fn {fsize, _fname}, size -> size + fsize end)

    Enum.reduce(dirs, 0, fn dir, acc ->
      ret = dir_size(Map.get(entries, dir), entries, cwd_file_sizes)

      acc + ret
    end)
  end
end

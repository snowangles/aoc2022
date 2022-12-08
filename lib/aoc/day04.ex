defmodule Aoc.Day04 do
  def part1(args) do
    Enum.map(args, &score_line/1) |> Enum.sum()
  end

  def part2(args) do
    Enum.map(args, &score_part2/1) |> Enum.sum()
  end

  def score_part2(line) do
    case parse_line(line) |> overlaps do
      true ->
        1

      false ->
        0
    end
  end

  def score_line(line) do
    case parse_line(line) |> contains do
      true ->
        1

      false ->
        0
    end
  end

  def parse_line(line) do
    [xs, xe, ys, ye] =
      Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, line)
      |> tl
      |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)

    [{xs, xe}, {ys, ye}]
  end

  def contains([{xs, xe}, {ys, ye}]) do
    (xs <= ys and xe >= ye) || (ys <= xs and ye >= xe)
  end

  def overlaps([{xs, xe}, {ys, _}]) when xs < ys do
    xe >= ys
  end

  def overlaps([{xs, _}, {ys, ye}]) when ys < xs do
    ye >= xs
  end

  def overlaps(_) do
    true
  end
end

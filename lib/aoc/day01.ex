defmodule Aoc.Day01 do
  require Record

  Record.defrecord(:max_curr, max: 0, current: 0)

  def part1(args) do
    acc =
      List.foldl(parse_data(args), max_curr(), fn
        "", acc = max_curr(max: max, current: current) when current > max ->
          max_curr(acc, max: current, current: 0)

        "", acc ->
          max_curr(acc, current: 0)

        cal, acc = max_curr(current: current) ->
          max_curr(acc, current: current + cal)
      end)

    max(max_curr(acc, :max), max_curr(acc, :current))
  end

  def part2(args) do
    table = :ets.new(:day01, [:ordered_set])

    acc =
      List.foldl(parse_data(args), max_curr(), fn
        "", acc = max_curr(current: current) ->
          :ets.insert(table, {current})
          max_curr(acc, current: 0)

        cal, acc = max_curr(current: current) ->
          max_curr(acc, current: current + cal)
      end)

    :ets.insert(table, {max_curr(acc, :current)})

    first = :ets.last(table)
    second = :ets.prev(table, first)
    third = :ets.prev(table, second)

    :ets.delete(table)

    first + second + third
  end

  defp parse_data(args) do
    Enum.map(args, fn
      "" -> ""
      arg -> String.to_integer(arg)
    end)
  end
end

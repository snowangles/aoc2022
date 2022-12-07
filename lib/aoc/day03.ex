defmodule Codepoint do
  import Bitwise

  defstruct value: 0

  def new(), do: %__MODULE__{}

  defimpl Collectable do
    @impl Collectable
    def into(cp) do
      {cp.value, &collectp/2}
    end

    defp collectp(cp, {:cont, element}) do
     Codepoint.collect(cp, element)
    end

    defp collectp(cp, command) when command in [:done, :halt] do
      cp
    end
  end

  def collect(cp, element) do
    bor(cp, 1 <<< codepoint(element))
  end

  defp codepoint(x) when x < ?a do
    x - ?A + 26
  end

  defp codepoint(x) do
    x - ?a
  end
end

defmodule Aoc.Day03 do
  import Bitwise

  def part1(args) do
    Enum.map(args, fn l ->
      len = String.length(l) >>> 1
      <<xs::binary-size(len), ys::binary-size(len)>> = l
      parse_part1(xs, ys, 0, 0)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    parse_part2(args, 0)
  end

  defp parse_part2([], acc) do
    acc
  end

  defp parse_part2([l1, l2, l3 | xs], acc) do
    l1cp = for <<b <- l1>>, into: Codepoint.new(), do: b
    l2cp = for <<b <- l2>>, into: Codepoint.new(), do: b
    l3cp = for <<b <- l3>>, into: Codepoint.new(), do: b

    parse_part2(xs, clz(band(l1cp, l2cp) |> band(l3cp)) + 1 + acc)
  end

  defp parse_part1(<<x, xs::binary>>, <<y, ys::binary>>, acc_x, acc_y) do
    acc_x_new = Codepoint.collect(acc_x, x)
    acc_y_new = Codepoint.collect(acc_y, y)

    case band(acc_x_new, acc_y_new) do
      0 ->
        parse_part1(xs, ys, acc_x_new, acc_y_new)

      n1 ->
        clz(n1) + 1
    end
  end

  @doc """
  count leading zeros
  """
  def clz(n) do
    clz(n, 0)
  end

  defp clz(n, m) do
    case band(n, 1 <<< m) do
      0 ->
        clz(n, m + 1)

      _ ->
        m
    end
  end
end

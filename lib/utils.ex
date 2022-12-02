defmodule Aoc.Utils do
  def read_data(day, type \\ :normal) do
    data_path(day, type)
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim(&1))
  end

  defp pad_day(day) do
    :io_lib.fwrite("~2..0B", [day])
  end

  defp type_part(:normal) do
    ""
  end

  defp type_part(:sample) do
    ".sample"
  end

  defp data_path(day, type) do
    filename = "p#{pad_day(day)}#{type_part(type)}.txt"
    Path.join("data", filename)
  end
end

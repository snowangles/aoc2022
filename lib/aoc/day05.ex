defmodule Aoc.Day05 do
  # empty record, done
  def decode_line(<<"   ">>, acc) do
    :ok
  end

  # crate, done
  def decode_line(<<"[">> <> <<crate::binary-size(1)>> <> "]", acc) do
    :ok
  end

  # empty record
  def decode_line(<<"    ">> <> <<rest::binary>>, {qs, idx}) do
    qs =
      case Enum.at(qs, idx) do
        nil ->
          qs ++ [:queue.new()]

        q ->
          q
      end

    decode_line(rest, {qs, idx + 1})
  end

  # crate
  def decode_line(
        <<"[">> <> <<crate::binary-size(1)>> <> "]" <> <<" ">> <> <<rest::binary>>,
        {qs, idx}) do
    qs =
      case Enum.at(qs, idx) do
        nil ->
          qs ++ [:queue.in(crate, :queue.new())]

        q ->
          List.replace_at(qs, idx, :queue.in(crate, q))
      end

    decode_line(rest, {qs, idx + 1})
  end
end

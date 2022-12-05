defmodule Aoc.Day02 do
  require Record

  Record.defrecord(:rps_result,
    rock: :undefined,
    paper: :undefined,
    scissor: :undefined,
    tie: :undefined,
    win: :undefined,
    lose: :undefined
  )

  def part1(args) do
    Enum.map(args, &parse_part1/1) |> Enum.sum()
  end

  def part2(args) do
    Enum.map(args, &parse_part2/1) |> Enum.sum()
  end

  def parse_part1(<<moveA::bytes-size(1)>> <> " " <> <<moveB::bytes-size(1)>>) do
    moveA = decode_move(moveA)
    moveB = decode_move(moveB)
    score_result(moveA, moveB) + score_move(moveB)
  end

  def parse_part2(<<moveA::bytes-size(1)>> <> " " <> <<moveB::bytes-size(1)>>) do
    {moveA, _} = decode_move(moveA)
    {result, result_idx} = decode_desired_result(moveB)

    moveB = :erlang.element(result_idx, rps(moveA))

    score_result(result) + score_move({moveB, :undefined})
  end

  def rps(:rock) do
    {:rps_result, :tie, :win, :lose, :rock, :paper, :scissor}
  end

  def rps(:paper) do
    {:rps_result, :lose, :tie, :win, :paper, :scissor, :rock}
  end

  def rps(:scissor) do
    {:rps_result, :win, :lose, :tie, :scissor, :rock, :paper}
  end

  defp decode_desired_result("X"), do: {:lose, rps_result(:lose) + 1}
  defp decode_desired_result("Y"), do: {:tie, rps_result(:tie) + 1}
  defp decode_desired_result("Z"), do: {:win, rps_result(:win) + 1}

  defp decode_move("A"), do: {:rock, rps_result(:rock)}
  defp decode_move("B"), do: {:paper, rps_result(:paper)}
  defp decode_move("C"), do: {:scissor, rps_result(:scissor)}
  defp decode_move("X"), do: {:rock, rps_result(:rock)}
  defp decode_move("Y"), do: {:paper, rps_result(:paper)}
  defp decode_move("Z"), do: {:scissor, rps_result(:scissor)}

  defp score_move({:rock, _}), do: 1
  defp score_move({:paper, _}), do: 2
  defp score_move({:scissor, _}), do: 3

  defp score_result({moveA, _}, {_, moveBIdx}) do
    score_result(:erlang.element(moveBIdx + 1, rps(moveA)))
  end

  defp score_result(:win), do: 6
  defp score_result(:lose), do: 0
  defp score_result(:tie), do: 3
end

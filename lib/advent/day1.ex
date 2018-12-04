defmodule Advent.Day1 do
  def do_task_1(_params) do
    IO.read(:stdio, :all)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> summarize
    |> IO.inspect
  end

  def do_task_2(_params) do
    IO.read(:stdio, :all)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn i, {current, seen} ->

      frequency = current + i
      if MapSet.member?(seen, frequency) do
        {:halt, frequency}
      else
        {:cont, {frequency, MapSet.put(seen, frequency)}}
      end
    end)
    |> IO.inspect
  end

  defp summarize(enumerator) do
    Enum.reduce(enumerator, fn x, acc-> x + acc end)
  end
end
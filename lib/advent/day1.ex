defmodule Advent.Day1 do
  @moduledoc ~S"""
    [Advent Of Code day 1](https://adventofcode.com/2018/day/1).
  """

  @spec do_task_1(input_data :: String.t())  :: integer()
  def do_task_1(input_data) do
    input_data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> summarize
    |> IO.inspect
  end

  @spec do_task_2(input_data :: String.t())  :: integer()
  def do_task_2(input_data) do
    input_data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle()
    |> find_double
    |> IO.inspect
  end

  defp summarize(enumerator) do
    Enum.reduce(enumerator, fn x, acc-> x + acc end)
  end

  defp find_double(enumerator) do
    Enum.reduce_while(enumerator, {0, MapSet.new([0])}, fn i, {current, seen} ->

      frequency = current + i
      if MapSet.member?(seen, frequency) do
        {:halt, frequency}
      else
        {:cont, {frequency, MapSet.put(seen, frequency)}}
      end
    end)
  end
end
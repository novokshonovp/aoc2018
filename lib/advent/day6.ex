defmodule Advent.Day6 do
  require IEx;
  @moduledoc ~S"""
    [Advent Of Code day 6](https://adventofcode.com/2018/day/6).
  """
  @spec do_task_1(input_data :: String.t())  :: integer()
  def do_task_1(input_data) do
    input_data
    |> String.trim_trailing
  end
end
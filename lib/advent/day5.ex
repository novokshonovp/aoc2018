defmodule Advent.Day5 do
  require IEx;
  @moduledoc ~S"""
    [Advent Of Code day 5](https://adventofcode.com/2018/day/5).
  """
  @spec do_task_1(input_data :: String.t())  :: integer()
  def do_task_1(input_data) do
    input_data
    |> String.trim_trailing
    |> String.graphemes
    |> react_units([])
    |> String.length
  end

  @spec do_task_2(input_data :: String.t())  :: integer()
  def do_task_2(input_data) do
    trimmed_input_data = String.trim_trailing(input_data)
    char_range = trimmed_input_data |> String.downcase |> String.graphemes |> Enum.uniq

    char_range
    |> Enum.reduce(trimmed_input_data, fn(char_to_trim, best_candidate) ->
      {_, regexp} = Regex.compile("#{char_to_trim}|#{String.upcase(char_to_trim)}")

      candidate = trimmed_input_data
      |> String.replace(regexp, "")
      |> String.graphemes
      |> react_units([])

      if String.length(best_candidate) > String.length(candidate), do: candidate, else: best_candidate
    end)
    |> String.length
  end

  defp react_units([], reacted_units), do: Enum.join(reacted_units) |> String.reverse

  defp react_units([head|queue_to_react], []), do: react_units(queue_to_react, [head])

  defp react_units([head_in_queue_to_react|tail_in_queue_to_react], [reacted_head|reacted_tail] = reacted_units) do
    if is_unit_reacting?(head_in_queue_to_react, reacted_head) do
      react_units(tail_in_queue_to_react, reacted_tail)
    else
      react_units(tail_in_queue_to_react, [head_in_queue_to_react] ++ reacted_units)
    end
  end

  defp is_unit_reacting?(first_unit, second_unit) do
    first_unit_code = first_unit |> to_charlist |> hd
    second_unit_code = second_unit |> to_charlist |> hd
    abs(first_unit_code - second_unit_code) == 32
  end
end
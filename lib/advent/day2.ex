defmodule Advent.Day2 do
  @moduledoc ~S"""
    [Advent Of Code day 2](https://adventofcode.com/2018/day/2).
  """
  @spec do_task_1(input_data :: String.t())  :: integer()
  def do_task_1(input_data) do
    input_data
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, 0}, fn(element, {count_of_doubles, count_of_triples}) ->
      {doubles, triples} = find_doubles_and_triples(element)
      {count_of_doubles + doubles, count_of_triples + triples}
    end)
    |> checksum
  end

  @spec do_task_2(input_data :: String.t())  :: String.t()
  def do_task_2(input_data) do
    input_data
    |> String.split("\n", trim: true)
    |> find_differ
    |> prepare_output
  end

  defp find_doubles_and_triples(string) do
    string
    |> String.graphemes
    |> Enum.sort
    |> Enum.chunk_by(fn arg -> arg end)
    |> Enum.reduce({0, 0}, fn(arg, {doubles, triples}) ->
      length = length(arg)
      acc_doubles = if length == 2 && doubles == 0 do 1 else 0 end
      acc_triples = if length == 3 && triples == 0 do 1 else 0 end
      {doubles + acc_doubles, triples + acc_triples}
    end)
  end

  defp checksum({doubles, triples}) do
    doubles * triples
  end

  defp find_differ(enumerator) do
    [head | tail] = enumerator
    x = Enum.reduce_while(tail, -1, fn(el, _) ->
      if is_elements_equal?(el, head) do  {:halt, {head, el}} else {:cont, 0} end
    end)
    if x == 0 do find_differ(tail) else x end
  end

  defp is_elements_equal?(first, second) do
    first_letters = String.graphemes(first)
    second_letters =  String.graphemes(second)
    number_of_not_equals = first_letters
                           |>Enum.with_index
                           |> Enum.map(fn ({el, index}) -> el == Enum.at(second_letters, index) end)
                           |> Enum.filter(fn(el) -> el == false end) |> length
    number_of_not_equals == 1
  end

  defp prepare_output({first, second}) do
    firsts = String.graphemes(first)
    seconds = String.graphemes(second)
    Enum.with_index(firsts) |> Enum.reject(fn({el, index}) -> el != Enum.at(seconds, index)end) |> Enum.map(fn({el, _}) -> el end) |> Enum.join
  end
end
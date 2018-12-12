defmodule Advent.Day3 do
  @moduledoc ~S"""
    [Advent Of Code day 3](https://adventofcode.com/2018/day/3).
  """
  @spec do_task_1(input_data :: String.t())  :: integer()
  def do_task_1(input_data) do
    input_data
    |> get_double_areas
    |> MapSet.size
  end

  @spec do_task_1(input_data :: String.t())  :: term()
  def do_task_2(input_data) do
    doubles = get_double_areas(input_data)
    String.split(input_data, "\n", trim: true)
    |> Enum.reduce_while("", fn(claim, _) ->
          claim_data = convert_claim_to_matrix(claim)
          if Enum.all?(claim_data, fn(el) -> !MapSet.member?(doubles, el) end) do
            {:halt, claim}
          else
            {:cont, 0}
          end
       end)
  end

  defp get_double_areas(input_data) do
  {_, doubles} =
    String.split(input_data, "\n", trim: true)
    |> Enum.reduce({MapSet.new, MapSet.new}, fn(el, {diagram, doubles}) ->
      claim = convert_claim_to_matrix(el)
      Enum.reduce(claim, {diagram, doubles}, fn(el, {diagram, doubles}) ->
        if MapSet.member?(diagram, el), do: {diagram, MapSet.put(doubles, el)}, else: {MapSet.put(diagram, el), doubles}
      end)
    end)
    doubles
  end

  defp convert_claim_to_matrix(claim) do
    [margin_left, margin_top, fabric_wide, fabric_tall] = Regex.run(~r/@ (\d+),(\d+): (\d+)x(\d+)/, claim) |>  Enum.drop(1) |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..fabric_wide, [], fn(x, matrix) ->
      Enum.reduce(1..fabric_tall, matrix, fn(y, matrix) ->
        matrix ++ [[margin_left + (x - 1), margin_top + (y - 1)]]
      end)
    end)
  end
end
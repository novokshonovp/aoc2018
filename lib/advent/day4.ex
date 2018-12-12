defmodule Advent.Day4 do
  use Timex
  defmodule Event do
    @moduledoc """
      Event structure for time record stripe.
    """
    defstruct [:guard_id, :event, :date_time, :period]
  end


  @moduledoc ~S"""
    [Advent Of Code day 4](https://adventofcode.com/2018/day/4).
  """
  @spec do_task_1(input_data :: String.t())  :: integer()
  def do_task_1(input_data) do
    time_stamps = sort_in_chronological_order(input_data)
    time_record = create_event_stripe(time_stamps)
    |> create_time_record([])

    {max_sleeping_guard_id, _}  = get_count_of_minutes_by_guard_id(time_record) |> gem_max_by_value

    {most_sleeping_minute, _} = get_most_sleeping_minute_by_guard_id(time_record, max_sleeping_guard_id) |> gem_max_by_value

    [_, most_sleeping_minute] = Regex.run(~r/:(\d*)/, most_sleeping_minute)
    String.to_integer(most_sleeping_minute) * String.to_integer(max_sleeping_guard_id)
  end

  @spec do_task_2(input_data :: String.t())  :: integer()
  def do_task_2(input_data) do
    time_stamps = sort_in_chronological_order(input_data)
    time_record = create_event_stripe(time_stamps)
    |> create_time_record([])

    guard_ids  = Enum.reduce(time_record, MapSet.new, fn(tr, guard_ids) -> MapSet.put(guard_ids, tr.guard_id) end)

    {guard_id_with_time_stamp, _} = get_guards_by_most_sleeping_minute(time_record, guard_ids) |> gem_max_by_value
    [_, guard_id, most_sleeping_minute] = Regex.run(~r/(\d*)_\d{2}:(\d{2})/, guard_id_with_time_stamp)

    String.to_integer(guard_id) * String.to_integer(most_sleeping_minute)
  end

  defp sort_in_chronological_order(input_data) do
    String.split(input_data, "\n", trim: true)
    |> Enum.sort
  end

  defp create_time_record(event_stripe, time_record) do
    [head | tail] = event_stripe
    time_record = if head.event == :asleep do
      time_record ++ [%{head | period: Timex.Interval.new(from: head.date_time, until: Timex.shift(List.first(tail).date_time, seconds: -1))}]
      else
        time_record
    end

    if length(tail) > 1, do: create_time_record(tail, time_record), else: time_record
  end

  defp create_event_stripe(time_stamps) do
    {stripe, _} = Enum.reduce(time_stamps, {[], nil}, fn(time_stamp, {event_stripe, last_guard_id}) ->
                   event = parse_event(time_stamp, last_guard_id)
                   {event_stripe ++ [event], event.guard_id}
                end)
    stripe
  end

  defp parse_event(time_stamp, guard_id) do
    [_, date_time_stamp] = Regex.run(~r/\[(.*)]/, time_stamp)
    {_, date_time} = Timex.parse(date_time_stamp, "%Y-%m-%d %H:%M",  :strftime)

    event = %Event{date_time: date_time}
    if Regex.run(~r/\] (falls asleep)/, time_stamp) do
      %{event | guard_id: guard_id, event: :asleep}
    else
      if Regex.run(~r/Guard #(\d+)/, time_stamp) do
        [_, new_guard_id] = Regex.run(~r/Guard #(\d+)/, time_stamp)
        %{event | guard_id: new_guard_id, event: :awake}
      else
        %{event | guard_id: guard_id, event: :awake}
      end
    end
  end

  defp get_count_of_minutes_by_guard_id(time_record) do
    time_record
    |> Enum.reduce(%{}, fn(record, count) ->
         number_of_minutes = record.period |> Interval.duration(:minutes)
         Map.update(count, record.guard_id, number_of_minutes, fn(value) -> value + number_of_minutes end)
       end)
  end

  defp gem_max_by_value(enumerable) do
    Enum.max_by(enumerable, fn({_, value}) -> value end)
  end

  defp get_most_sleeping_minute_by_guard_id(time_record, guard_id) do
    Enum.reduce(time_record, [], fn(el, tr) ->
        if el.guard_id == guard_id, do: tr ++ [el], else: tr
    end)
    |> Enum.reduce(%{}, fn(record, sleeping_minutes) ->
        0..Interval.duration(record.period, :minutes)
        |> Enum.reduce(sleeping_minutes, fn(minutes_shift, sleeping_minutes) ->
                       {_, key} = Timex.format(Timex.shift(record.date_time, minutes: minutes_shift), "{h24}:{m}")
                       Map.update(sleeping_minutes, key, 1, fn(el) -> el + 1 end)
           end)
    end)
  end

  def get_guards_by_most_sleeping_minute(time_record, guard_ids) do
    Enum.reduce(guard_ids, %{}, fn(guard_id, guards_by_minutes) ->
      {time, minutes} = get_most_sleeping_minute_by_guard_id(time_record, guard_id) |> gem_max_by_value
      key = "#{guard_id}_#{time}"
      Map.update(guards_by_minutes, key, minutes, fn(el) -> el + minutes end)
    end)
  end
end
defmodule Tasks1 do
  use Bmark

  bmark :task1_2 do
    "cat input/day1.txt | ./advent --day 1 --task 2"
    |> String.to_charlist
    |> :os.cmd
  end
end
defmodule Tasks5 do
  use Bmark

  bmark :task5_1 do
    "cat input/day5.txt | ./advent --day 5 --task 1"
    |> String.to_charlist
    |> :os.cmd
  end
end
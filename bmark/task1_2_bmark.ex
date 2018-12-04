defmodule Task1_2 do
  use Bmark

  bmark :runner do
    "cat input/task1_2.txt | ./advent --day 1 --task 2"
    |> String.to_charlist
    |> :os.cmd
  end
end
defmodule Advent.CLI do
  def main(args) do
    args |> parse_args |> process
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [task: :string, day: :string])
    options
  end

  defp process([]) do
    IO.puts "No args ?!"
  end

  defp process(options) do
#    try do
      inputs = IO.read(:stdio, :all)
      apply(String.to_atom("Elixir.Advent.Day#{options[:day]}"), String.to_atom("do_task_#{options[:task]}"), [inputs])
#    rescue
#      UndefinedFunctionError -> IO.puts "Not impelemnted yet :whoa: !"
#    end
  end
end

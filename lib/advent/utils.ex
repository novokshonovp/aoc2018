defmodule Utils.String do
  def upcase?(string) do
    string == String.upcase(string)
  end

  def downcase?(string) do
    string == String.downcase(string)
  end

  def stripchars(str, chars) do
    String.replace(str, ~r/[#{chars}]/, "")
  end
end

defmodule Utils.Map do
  def gem_max_by_value(enumerable) do
    Enum.max_by(enumerable, fn({_, value}) -> value end)
  end
end

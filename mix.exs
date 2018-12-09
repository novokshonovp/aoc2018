defmodule Advent.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent,
      version: "0.0.1",
      escript: escript(),
      deps: deps()
    ]
  end

  defp escript do
    [main_module: Advent.CLI]
  end

  defp deps do
    [
      {:bmark, "~> 1.0.0"}
    ]
  end
end


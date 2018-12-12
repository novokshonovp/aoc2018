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
      {:bmark, "~> 1.0.0"},
      {:timex, "~> 3.4"},
      {:tzdata, "~> 0.1.7", override: true},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end
end


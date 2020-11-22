defmodule Amelia.MixProject do
  use Mix.Project

  def project do
    [
      app: :amelia,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :snowflake, :mongodb, :crypto],
      mod: {Amelia, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.10.4"},
      {:plug_cowboy, "~> 2.0"},
      {:cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:snowflake, "~> 1.0.0"},
      {:mongodb, "~> 0.5.1"},
      {:argon2_elixir, "~> 2.0"},
      {:recase, "~> 0.5"},
      {:ex_rated, "~> 2.0"},
    ]
  end
end

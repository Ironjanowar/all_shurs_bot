defmodule AllShursBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :all_shurs_bot,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AllShursBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.22"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      {:jason, "~> 1.2"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, "~> 0.15"},
      {:logger_file_backend, "0.0.11"}
    ]
  end
end

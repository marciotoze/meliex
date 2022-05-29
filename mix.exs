defmodule Meliex.MixProject do
  use Mix.Project

  def project do
    [
      app: :meliex,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Meliex",
      source_url: "https://github.com/marciotoze/meliex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:hackney, "~> 1.18"},
      {:jason, ">= 1.3.0"},
      {:tesla, "~> 1.4"},
      {:timex, "~> 3.7.6"}
    ]
  end

  defp description do
    "Mercado Libre API wrapper"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Marcio Toze"],
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/marciotoze/meliex"}
    ]
  end
end

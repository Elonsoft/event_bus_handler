defmodule EventBusHandler.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :event_bus_handler,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "EventBusHandler",
      docs: docs(),

      # Hex
      description: description(),
      package: package()
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
      {:event_bus, ">= 1.6.0"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "EventBusHandler",
      extras: ["README.md"],
      source_url: "https://github.com/Elonsoft/event_bus_handler"
    ]
  end

  defp description do
    "EventBus helper that manages event handler supervision."
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/Elonsoft/event_bus_handler"},
      licenses: ["MIT"],
      files: ~w(.formatter.exs mix.exs README.md LICENSE.md lib)
    ]
  end
end

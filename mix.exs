defmodule ThumbHash.MixProject do
  use Mix.Project

  def project do
    [
      app: :thumb_hash,
      name: "ThumbHash",
      description: "An Elixir bridge to the Rust ThumbHash library.",
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/portal-labs/thumb_hash",
      homepage_url: "https://github.com/portal-labs/thumb_hash"
    ]
  end

  defp package() do
    [
      files: ~w(lib native .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/portal-labs/thumb_hash"}
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
      {:image, "~> 0.55.2"},
      {:rustler, "~> 0.35"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end

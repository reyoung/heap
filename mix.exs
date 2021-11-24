defmodule Heap.MixProject do
  use Mix.Project

  def project do
    [
      app: :heap_pq,
      version: "1.0.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Heap",
      source_url: "https://github.com/reyoung/heap.git",
      description:
        "A flexible implementation of custom-priority heap/priority queue based on the leftist-heaps",
      package: package()
    ]
  end

  def application do
    []
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/reyoung/heap.git"}
    ]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev, runtime: false}]
  end
end

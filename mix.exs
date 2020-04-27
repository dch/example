defmodule Example.MixProject do
  use Mix.Project

  def project() do
    {tag, version} = git_version()

    [
      app: :example,
      version: tag,
      id: version,
      description: "Example v" <> version,
      start_permanent: Mix.env() == :prod,
      # http://erlang.org/doc/man/dialyzer.html
      dialyzer: [
        flags: ["-Wunmatched_returns", :error_handling, :race_conditions, :underspecs],
        list_unused_filters: true
      ],
      deps: deps()
    ]
  end

  defp git_version() do
    # pulls version information from "nearest" git tag or sha hash-ish
    {hashish, 0} =
      System.cmd("git", ~w[describe --dirty --abbrev=7 --tags --always --first-parent])

    full_version = String.trim(hashish)

    tag_version =
      hashish
      |> String.split("-")
      |> List.first()
      |> String.replace_prefix("v", "")
      |> String.trim()

    tag_version =
      case Version.parse(tag_version) do
        :error -> "0.0.0-#{tag_version}"
        _ -> tag_version
      end

    {tag_version, full_version}
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [:logger],
      mod: {Example.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:gen_rmq, "~> 2.5.0"},
      {:jason, "~> 1.2"},
      {:katja_vmstats, github: "katja-beam/katja_vmstats", tag: "v0.8.1", only: :prod},
      {:logger_syslog_backend, "~> 1.0"},
      {:telemetry_metrics_riemann, "~> 0.2"}
    ]
  end
end

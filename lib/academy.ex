defmodule Academy do
  @moduledoc ~S"""
  The main application: where everything starts.
  """

  use Application

  require Prometheus.Registry

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Academy.Endpoint, []),
      # Start the Ecto repository
      supervisor(Academy.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Academy.Worker, [arg1, arg2, arg3]),
      supervisor(Academy.Endpoint.LDAP, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Academy.Supervisor]

    Academy.Metrics.PhoenixInstrumenter.setup()
    Academy.Metrics.PipelineInstrumenter.setup()
    Academy.Metrics.RepoInstrumenter.setup()
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    Academy.Metrics.PrometheusExporter.setup()

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Academy.Endpoint.config_change(changed, removed)
    :ok
  end
end

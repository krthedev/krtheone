defmodule Krtheone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KrtheoneWeb.Telemetry,
      Krtheone.Repo,
      {DNSCluster, query: Application.get_env(:krtheone, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Krtheone.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Krtheone.Finch},
      # Start a worker by calling: Krtheone.Worker.start_link(arg)
      # {Krtheone.Worker, arg},
      # Start to serve requests, typically the last entry
      KrtheoneWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Krtheone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KrtheoneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

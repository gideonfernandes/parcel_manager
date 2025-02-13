defmodule ParcelManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Oban.Telemetry.attach_default_logger()

    children = [
      ParcelManagerWeb.Telemetry,
      ParcelManager.Infrastructure.Persistence.Repo,
      {DNSCluster, query: Application.get_env(:parcel_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ParcelManager.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ParcelManager.Finch},
      # Start a worker by calling: ParcelManager.Worker.start_link(arg)
      # {ParcelManager.Worker, arg},
      # Start to serve requests, typically the last entry
      ParcelManagerWeb.Endpoint,
      {Oban, Application.fetch_env!(:parcel_manager, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ParcelManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ParcelManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

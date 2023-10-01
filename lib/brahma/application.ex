defmodule Brahma.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BrahmaWeb.Telemetry,
      # Start the Ecto repository
      Brahma.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Brahma.PubSub},
      # Start Finch
      {Finch, name: Brahma.Finch},
      # Start the Endpoint (http/https)
      BrahmaWeb.Endpoint
      # Start a worker by calling: Brahma.Worker.start_link(arg)
      # {Brahma.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Brahma.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BrahmaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule UrlShortenerEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UrlShortenerExWeb.Telemetry,
      # Start the Ecto repository
      UrlShortenerEx.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: UrlShortenerEx.PubSub},
      # Start Finch
      {Finch, name: UrlShortenerEx.Finch},
      # Start the Endpoint (http/https)
      UrlShortenerExWeb.Endpoint,
      # Start a worker by calling: UrlShortenerEx.Worker.start_link(arg)
      # {UrlShortenerEx.Worker, arg}
      UrlShortenerEx.Cache,
      MyApp.UrlCleaner
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrlShortenerEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UrlShortenerExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

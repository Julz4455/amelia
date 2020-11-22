defmodule Amelia do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    db_url = (case Mix.env do
      :prod ->
        "mongodb://localhost:27017/amelia"
      _ ->
        "mongodb://localhost:27017/amelia-dev"
    end)

    children = [
      {Plug.Cowboy, scheme: :http, plug: Amelia.Router, options: [dispatch: dispatch(), port: 4000]},
      {Registry, keys: :duplicate, name: Registry.Amelia},
      {Mongo, [name: Amelia.Mongo, url: db_url, show_sensitive_data_on_connection_error: true]}
    ]

    Logger.info("Starting Amelia on port 4000.")
    opts = [strategy: :one_for_one, name: Amelia.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_, [
        # TODO: Add some gateway for post events.
        # {"/gateway", Amelia.SocketHandler, []},
        {:_, Plug.Cowboy.Handler, {Amelia.Router.Base, []}}
        ]
      }
    ]
  end
end

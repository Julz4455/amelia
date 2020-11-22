defmodule Amelia.Router.Base do
  use Plug.Router

  alias Amelia.Codes

  plug Plug.Logger
  plug :match
  plug Plug.Parsers,
    parsers: [:json],
    pass: ['application/json'],
    json_decoder: Poison
  plug Amelia.Plugs.CommonHeaders
  plug Amelia.Plugs.RateLimit,
    max_requests: 2, # 2 requests
    interval_seconds: 1 # per second
  plug :dispatch

  forward "/auth", to: Amelia.Router.Auth

  get "/ping" do
    conn
    |> send_resp(Codes.ok, Poison.encode!(%{
      message: "200: Ping",
      code: 0
    }))
  end

  post "/ping" do
    conn
    |> send_resp(Codes.ok, Poison.encode!(%{
      message: "200: Ping",
      code: 0
    }))
  end

  match "/brew-coffee" do
    conn
    |> send_resp(Codes.teapot, "I\'m a teapot.\nThe requested entity body is short and stout.\nTip me over and pour me out.")
  end

  match _ do
    conn
    |> send_resp(Codes.not_found, Poison.encode!(%{
      message: "404: Not Found",
      code: 0
    }))
  end
end

defmodule Amelia.Router.Auth do
  use Plug.Router

  alias Amelia.Codes
  alias Amelia.Errors

  plug Plug.Logger
  plug :match
  plug Plug.Parsers,
    parsers: [:json],
    pass: ['application/json'],
    json_decoder: Poison
  plug :dispatch

  post "/register" do
    body = conn.body_params
    reqs = ["username", "email", "password"]
    error = %{
      code: 50035,
      errors: Map.new,
      message: "Invalid Body"
    }

    body = Map.merge(Amelia.Utils.Map.nil_map(reqs), body)

    errors = body |> Map.to_list |> Enum.map(fn ({field, value}) ->
      if field in reqs && value == nil do
        {field, [Errors.gen_missing | Errors.gen(value, max_len: 32, min_len: 2, capture: &is_bitstring/1, type: "string", ax: 1)]}
      else
        if field == "password" do
          {field, Errors.gen(value, capture: &is_bitstring/1, type: "string", ax: 1, password: true)}
        else
          {field, Errors.gen(value, max_len: 32, min_len: 2, capture: &is_bitstring/1, type: "string", ax: 1)}
        end
      end
    end) |> Enum.map(fn {field, elist} -> ["_" <> field, elist] end)
    |> Enum.reduce(%{}, fn ([field, elist], acc) -> Map.put(acc, field, elist) end)
    error = %{error | errors: errors}

    IO.inspect error

    send_resp(conn, Codes.empty, "")
  end


end

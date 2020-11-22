defmodule Amelia.Plugs.CommonHeaders do
  @moduledoc """
  A plug that puts the application/json header to the Plug.Conn response.
  TODO: Add other headers later
  """

  import Plug.Conn

  @spec init :: keyword
  def init(), do: init([])

  @spec init(keyword) :: keyword
  def init(opts) do
    opts
  end

  @spec call(Plug.Conn.t, nil | list) :: Plug.Conn.t
  @doc """
  Main call function for header logic.
  """
  def call(conn, _opts) do
    conn |> put_resp_header("content-type", "application/json")
  end
end

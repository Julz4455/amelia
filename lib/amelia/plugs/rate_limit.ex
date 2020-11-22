defmodule Amelia.Plugs.RateLimit do
  @moduledoc """
  A plug that rate limits requests, using only ExRated.
  """

  import Plug.Conn

  @spec init :: keyword
  def init(), do: init([])

  @spec init(keyword) :: keyword
  def init(opts) do
    interval = Keyword.get(opts, :interval_seconds)
    max_reqs = Keyword.get(opts, :max_requests)

    if interval == nil do
      raise Amelia.Plugs.NoIntervalError
    end

    if max_reqs == nil do
      raise Amelia.Plugs.NoMaxRequestsError
    end

    opts
  end

  @spec deny_handler(Plug.Conn.t()) :: Plug.Conn.t()
  @doc """
  Deny Handler for Rate Limit

  TODO: Allow for deny handler configuration.
  """
  def deny_handler(conn) do
    calm = false
    status = if calm, do: 420, else: 429
    conn
    |> send_resp(status, Poison.encode!(%{
      message: "You are being rate limited.",
      code: 0
    }))
    |> halt
  end

  @spec call(Plug.Conn.t, nil | list) :: Plug.Conn.t
  @doc """
  Main call function for rate limit logic.
  """
  def call(conn, opts \\ []) do
    case check_rate(conn, opts) do
      {:ok, _count} -> conn # Allow exec
      {:error, _count} -> Amelia.Plugs.RateLimit.deny_handler(conn)
    end
  end

  # Private Helper Functions

  defp check_rate(conn, opts) do
    interval_ms = opts[:interval_seconds] * 1000
    max_reqs = opts[:max_requests]
    bucket_name = opts[:bucket] || bucket_name(conn)
    ExRated.check_rate(bucket_name, interval_ms, max_reqs)
  end

  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    "#{ip}:#{path}"
  end
end

defmodule Amelia.Plugs.NoIntervalError do
  defexception message: "Must specify a :interval_seconds"
end

defmodule Amelia.Plugs.NoMaxRequestsError do
  defexception message: "Must specify a :max_requests"
end

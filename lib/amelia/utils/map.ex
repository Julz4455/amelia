defmodule Amelia.Utils.Map do
  def nil_map(keys) do
    Enum.map(keys, fn k -> {k, nil} end) |> Map.new
  end
end

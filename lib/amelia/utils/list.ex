defmodule Amelia.Utils.List do

  # Flatten List w/ Depth
  def flatten(list) do
    list
    |> Enum.reduce([], fn (x, acc) ->
      x
      |> IO.inspect(label: "X")
      acc
      |> IO.inspect(label: "Accum")

      f = (if is_list(x), do: flatten(x), else: x)
      f |> IO.inspect(label: "Concat")
      [f | acc]
    end)
    |> Enum.reverse
  end
end

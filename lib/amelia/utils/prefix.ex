defmodule Amelia.Utils.Prefix do

  # TODO: Create an "add" function to add a prefix.

  @spec remove(bitstring, bitstring) :: bitstring
  def remove(string, prefix) do
    base = byte_size(prefix)
    <<_::binary-size(base), rest::binary>> = string
    rest
  end
end

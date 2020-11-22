defmodule AmeliaTest do
  use ExUnit.Case
  doctest Amelia

  test "greets the world" do
    assert Amelia.hello() == :world
  end
end

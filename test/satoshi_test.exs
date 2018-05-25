defmodule SatoshiTest do
  use ExUnit.Case
  doctest Satoshi

  test "greets the world" do
    assert Satoshi.hello() == :world
  end
end

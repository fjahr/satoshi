defmodule Satoshi.Base58Test do
  use ExUnit.Case, async: true

  test "encode!" do
    assert Satoshi.Base58.encode!("hello") == "Cn8eVZg"
  end
end

defmodule Satoshi.OwnTest do
  use ExUnit.Case, async: true

  alias Satoshi.{Own, Util}

  test "my_sec" do
    s = Util.pow(999, 3)
    uncompressed = "049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9"
    compressed = "039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5"

    assert Own.my_sec(secret: s, compressed: false) == Base.decode16!(uncompressed, case: :lower)
    assert Own.my_sec(secret: s, compressed: true) == Base.decode16!(compressed, case: :lower)

    s = 123
    uncompressed = "04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
    compressed = "03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5"

    assert Own.my_sec(secret: s, compressed: false) == Base.decode16!(uncompressed, case: :lower)
    assert Own.my_sec(secret: s, compressed: true) == Base.decode16!(compressed, case: :lower)

    s = 42424242
    uncompressed = "04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3"
    compressed = "03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e"

    assert Own.my_sec(secret: s, compressed: false) == Base.decode16!(uncompressed, case: :lower)
    assert Own.my_sec(secret: s, compressed: true) == Base.decode16!(compressed, case: :lower)
  end

  test "address/1" do
    s = Util.pow(888, 3)
    mainnet_address = "148dY81A9BmdpMhvYEVznrM45kWN32vSCN"
    testnet_address = "mieaqB68xDCtbUBYFoUNcmZNwk74xcBfTP"

    assert Own.my_address(s, blockchain: :mainnet) == mainnet_address
    assert Own.my_address(s) == testnet_address

    s = 321
    mainnet_address = "1S6g2xBJSED7Qr9CYZib5f4PYVhHZiVfj"
    testnet_address = "mfx3y63A7TfTtXKkv7Y6QzsPFY6QCBCXiP"

    assert Own.my_address(s, compressed: false, blockchain: :mainnet) == mainnet_address
    assert Own.my_address(s, compressed: false) == testnet_address

    s = 4242424242
    mainnet_address = "1226JSptcStqn4Yq9aAmNXdwdc2ixuH9nb"
    testnet_address = "mgY3bVusRUL6ZB2Ss999CSrGVbdRwVpM8s"

    assert Own.my_address(s, compressed: false, blockchain: :mainnet) == mainnet_address
    assert Own.my_address(s, compressed: false) == testnet_address
  end
end

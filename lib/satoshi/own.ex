defmodule Satoshi.Own do
  import Integer

  alias Satoshi.Own.Point
  alias Satoshi.{Util, Base58}

  def my_sec(secret: s, compressed: compressed) do
    p = Point.rmul(Point.g(), s)
    x_binary = Integer.to_string(p.x.value, 16) |> String.downcase()
    y_binary = Integer.to_string(p.y.value, 16) |> String.downcase()

    address =
      if compressed do
        if is_even(p.y.value) do
          "02" <> x_binary
        else
          "03" <> x_binary
        end
      else
        "04" <> x_binary <> y_binary
      end

    Base.decode16!(address, case: :lower)
  end

  def my_address(secret, options \\ []) do
    defaults = [compressed: true, blockchain: :testnet]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    sec = my_sec(secret: secret, compressed: options.compressed)

    hash160 = Util.hash160!(sec)

    raw = if options.blockchain == :testnet do
        <<0x6f>> <> hash160
      else
        <<0x00>> <> hash160
      end

    <<checksum::32>> <> _rest = Util.double_sha256!(raw)

    Base58.encode!(raw <> <<checksum::32>>)
  end
end

defmodule Satoshi.Own.Point do
  @moduledoc """
  Finite field element struct.
  """
  alias Satoshi.Own.FieldElement

  @s256a 0
  @s256b 7

  @gx 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
  @gy 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

  @enforce_keys [:x, :y, :a, :b]
  defstruct [:x, :y, :a, :b]

  def s256point(raw_x, raw_y) do
    x = FieldElement.new_s256(value: raw_x)
    y = FieldElement.new_s256(value: raw_y)

    %__MODULE__{x: x, y: y, a: @s256a, b: @s256b}
  end

  def g() do
    s256point(@gx, @gy)
  end
end

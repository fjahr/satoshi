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

  def new(x: x, y: y, a: a, b: b, prime: prime) do
    fe_x = FieldElement.new(value: x, prime: prime)
    fe_y = FieldElement.new(value: y, prime: prime)

    %__MODULE__{x: fe_x, y: fe_y, a: a, b: b}
  end
  def new(x: x, y: y, a: a, b: b), do: %__MODULE__{x: x, y: y, a: a, b: b}

  def s256point(raw_x, raw_y) do
    x = FieldElement.new_s256(value: raw_x)
    y = FieldElement.new_s256(value: raw_y)

    p = %__MODULE__{x: x, y: y, a: @s256a, b: @s256b}

    if point_on_s256?(p) do
      p
    else
      raise ArgumentError, "Point is not on secp256k1"
    end
  end

  def g() do
    s256point(@gx, @gy)
  end

  def eq(%__MODULE__{x: x, y: y, a: a, b: b}, %__MODULE__{x: x, y: y, a: a, b: b}) do
    true
  end
  def eq(_, _), do: false

  def add(%__MODULE__{x: %{value: nil, prime: _}, y: %{value: nil, prime: _}, a: _, b: _}, p2), do: p2
  def add(p1, %__MODULE__{x: %{value: nil, prime: _}, y: %{value: nil, prime: _}, a: _, b: _}), do: p1
  def add(%__MODULE__{x: x, y: y, a: a, b: b}, %__MODULE__{x: x, y: y, a: a, b: b}) do
    s = FieldElement.pow(x, 2)
        |> FieldElement.rmul(3)
        |> FieldElement.add(a)
        |> FieldElement.div(FieldElement.rmul(y, 2))

    new_x = FieldElement.pow(s, 2)
        |> FieldElement.sub(FieldElement.rmul(x, 2))

    new_y = FieldElement.sub(x, new_x)
            |> FieldElement.mul(s)
            |> FieldElement.sub(y)

    new(x: new_x, y: new_y, a: a, b: b)
  end
  def add(%__MODULE__{x: x, y: y1, a: a, b: b}, %__MODULE__{x: x, y: y2, a: a, b: b}) do
    new(x: nil, y: nil, a: a, b: b, prime: x.prime)
  end
  def add(%__MODULE__{x: x1, y: y1, a: a, b: b}, %__MODULE__{x: x2, y: y2, a: a, b: b}) do
    s = FieldElement.sub(y2, y1)
        |> FieldElement.div(FieldElement.sub(x2, x1))

    new_x = FieldElement.pow(s, 2)
        |> FieldElement.sub(x1)
        |> FieldElement.sub(x2)

    new_y = FieldElement.sub(x1, new_x)
            |> FieldElement.mul(s)
            |> FieldElement.sub(y1)

    new(x: new_x, y: new_y, a: a, b: b)
  end
  def add(_, _), do: raise ArgumentError, "Point addition not possible for these parameters"

  def rmul(p, s) do
    x = FieldElement.new(value: nil, prime: p.x.prime)
    y = FieldElement.new(value: nil, prime: p.y.prime)

    rmul(p, s, __MODULE__.new(x: x, y: y, a: p.a, b: p.b))
  end
  defp rmul(p, 0, product), do: product
  defp rmul(p, s, product), do: rmul(p, s-1, __MODULE__.add(product, p))


  defp point_on_s256?(p) do
    left_side = FieldElement.pow(p.y, 2)
    right_side = FieldElement.pow(p.x, 3)
                 |> FieldElement.add(FieldElement.rmul(p.x, p.a))
                 |> FieldElement.add(p.b)

    left_side == right_side
  end
end

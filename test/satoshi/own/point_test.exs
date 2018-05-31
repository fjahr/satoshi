defmodule Satoshi.Own.PointTest do
  use ExUnit.Case, async: true
  doctest Satoshi.Own.Point

  alias Satoshi.Own.{FieldElement, Point}

  test "g() returns the s256 generator point" do
    assert Point.g() == %Satoshi.Own.Point{
                          a: 0,
                          b: 7,
                          x: %FieldElement{
                            prime: 115792089237316195423570985008687907853269984665640564039457584007908834671663,
                            value: 55066263022277343669578718895168534326250603453777594175500187360389116729240
                          },
                          y: %FieldElement{
                            prime: 115792089237316195423570985008687907853269984665640564039457584007908834671663,
                            value: 32670510020758816978083085130507043184471273380659243275938904335757337482424
                          }
                        }
  end

  test "s256point raises error if point is not on curve" do
    assert_raise ArgumentError, fn ->
      Point.s256point(24, 220)
    end
  end

  test "eq test for equality in points" do
    p1 = Point.new(x: 2, y: 5, a: 5, b: 7, prime: 97)
    p2 = Point.new(x: 2, y: 5, a: 5, b: 7, prime: 97)
    p3 = Point.new(x: 2, y: -5, a: 5, b: 7, prime: 97)

    assert Point.eq(p1, p2) == true
    assert Point.eq(p2, p3) == false
  end

  test "add/2 is performing point addition" do
    a = Point.new(x: nil, y: nil, a: 5, b: 7, prime: 223)
    b = Point.new(x: 2, y: 5, a: 5, b: 7, prime: 223)
    c = Point.new(x: 2, y: 6, a: 5, b: 7, prime: 223)

    assert Point.add(a, b) == b
    assert Point.add(b, a) == b
    assert Point.add(b, c) == a

    d = Point.new(x: 3, y: 7, a: 5, b: 7, prime: 223)
    e = Point.new(x: 1, y: 1, a: 5, b: 7, prime: 223)
    assert Point.add(d, e) == Point.new(x: 5, y: 210, a: 5, b: 7, prime: 223)

    f = Point.new(x: 1, y: 1, a: 5, b: 7, prime: 223)
    assert Point.add(f, f) == Point.new(x: 14, y: 170, a: 5, b: 7, prime: 223)
  end
end

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
end

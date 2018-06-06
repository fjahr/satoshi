defmodule Satoshi.Own.PointTest do
  use ExUnit.Case, async: true
  doctest Satoshi.Own.Point

  alias Satoshi.Own.{FieldElement, Point}
  alias Satoshi.Util

  test "g() returns the s256 generator point" do
    assert Point.g() == %Satoshi.Own.Point{
                          a: %FieldElement{
                            prime: 115792089237316195423570985008687907853269984665640564039457584007908834671663,
                            value: 0
                          },
                          b: %FieldElement{
                            prime: 115792089237316195423570985008687907853269984665640564039457584007908834671663,
                            value: 7
                          },
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
    c = Point.new(x: 2, y: 218, a: 5, b: 7, prime: 223)

    assert Point.add(a, b) == b
    assert Point.add(b, a) == b
    assert Point.add(b, c) == a

    d = Point.new(x: 3, y: 7, a: 5, b: 7, prime: 223)
    e = Point.new(x: 2, y: 5, a: 5, b: 7, prime: 223)
    assert Point.add(d, e) == Point.new(x: 222, y: 1, a: 5, b: 7, prime: 223)

    f = Point.new(x: 2, y: 5, a: 5, b: 7, prime: 223)
    assert Point.add(f, f) == Point.new(x: 126, y: 141, a: 5, b: 7, prime: 223)

    additions = [
      [192, 105, 17, 56, 170, 142],
      [47, 71, 117, 141, 60, 139],
      [143, 98, 76, 66, 47, 71],
    ]

    prime = 223
    s256a = FieldElement.new(value: 0, prime: prime)
    s256b = FieldElement.new(value: 7, prime: prime)

    for [x1_raw, y1_raw, x2_raw, y2_raw, x3_raw, y3_raw] <- additions do
      x1 = FieldElement.new(value: x1_raw, prime: prime)
      y1 = FieldElement.new(value: y1_raw, prime: prime)
      p1 = Point.new(x: x1, y: y1, a: s256a, b: s256b)
      x2 = FieldElement.new(value: x2_raw, prime: prime)
      y2 = FieldElement.new(value: y2_raw, prime: prime)
      p2 = Point.new(x: x2, y: y2, a: s256a, b: s256b)
      x3 = FieldElement.new(value: x3_raw, prime: prime)
      y3 = FieldElement.new(value: y3_raw, prime: prime)
      p3 = Point.new(x: x3, y: y3, a: s256a, b: s256b)

      assert Point.add(p1, p2) == p3
    end
  end

  test "rmul/2 is scaling a point" do
    prime = 223
    a = 0
    b = 7

    multiplications = [
      [2, 192, 105, 49, 71],
      [2, 143, 98, 64, 168],
      [2, 47, 71, 36, 111],
      [4, 47, 71, 194, 51],
      [8, 47, 71, 116, 55],
      [21, 47, 71, nil, nil],
    ]

    for [s, x1, y1, x2, y2] <- multiplications do
      p1 = Point.new(x: x1, y: y1, a: a, b: b, prime: prime)
      p2 = Point.new(x: x2, y: y2, a: a, b: b, prime: prime)

      assert Point.rmul(p1, s) == p2
    end
  end

  test "test g multiplication with secrets to get to public points" do
    points = [
      [7, 0x5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc, 0x6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da],
      [1485, 0xc982196a7466fbbbb0e27a940b6af926c1a74d5ad07128c82824a11b5398afda, 0x7a91f9eae64438afb9ce6448a1c133db2d8fb9254e4546b6f001637d50901f55],
      [Util.pow(2, 128), 0x8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da, 0x662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82],
      [Util.pow(2, 240) + Util.pow(2, 31), 0x9577ff57c8234558f293df502ca4f09cbc65a6572c842b39b366f21717945116, 0x10b49c67fa9365ad7b90dab070be339a1daf9052373ec30ffae4f72d5e66d053],
    ]

    for [s, x, y] <- points do
      point = Point.s256point(x, y)
      assert Point.rmul(Point.g(), s) == point
    end
  end
end

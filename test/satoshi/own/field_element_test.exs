defmodule Satoshi.Own.FieldElementTest do
  use ExUnit.Case, async: true

  alias Satoshi.Own.FieldElement

  test "add works for valid field elements" do
    a = %FieldElement{value: 2, prime: 31}
    b = %FieldElement{value: 15, prime: 31}

    assert %FieldElement{value: 17, prime: 31} == FieldElement.add(a, b)

    a = %FieldElement{value: 17, prime: 31}
    b = %FieldElement{value: 21, prime: 31}

    assert %FieldElement{value: 7, prime: 31} == FieldElement.add(a, b)
  end

  test "sub works for valid field elements" do
    a = %FieldElement{value: 29, prime: 31}
    b = %FieldElement{value: 4, prime: 31}

    assert %FieldElement{value: 25, prime: 31} == FieldElement.sub(a, b)

    a = %FieldElement{value: 15, prime: 31}
    b = %FieldElement{value: 30, prime: 31}

    assert %FieldElement{value: 16, prime: 31} == FieldElement.sub(a, b)
  end

  test "mul works for valid field elements" do
    first = %FieldElement{value: 7, prime: 31}
    second = %FieldElement{value: 12, prime: 31}

    result = FieldElement.mul(first, second)

    assert %FieldElement{value: 22, prime: 31} == result
  end

  test "rmul works for valid field elements" do
    first = %FieldElement{value: 7, prime: 31}
    second = 5

    result = FieldElement.rmul(first, second)

    assert %FieldElement{value: 4, prime: 31} == result
  end

  test "pow works for valid field elements" do
    first = %FieldElement{value: 7, prime: 31}
    second = 5

    result = FieldElement.pow(first, second)

    assert %FieldElement{value: 5, prime: 31} == result
  end

  test "div works for valid field elements" do
    first = %FieldElement{value: 3, prime: 31}
    second = %FieldElement{value: 24, prime: 31}

    result = FieldElement.div(first, second)

    assert %FieldElement{value: 4, prime: 31} == result
  end

  test "combinatory methods raise error if primes don't match" do
    methods = [:add, :sub, :mul, :rmul, :div]

    for method <- methods do
      first = %FieldElement{value: 27, prime: 32}
      second = %FieldElement{value: 12, prime: 31}

      assert_raise ArgumentError, fn ->
        apply(FieldElement, method, [first, second])
      end
    end
  end

end

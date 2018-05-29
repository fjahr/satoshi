defmodule Satoshi.Own.FieldElementTest do
  use ExUnit.Case, async: true

  alias Satoshi.Own.FieldElement

  test "add works for valid field elements" do
    first = %FieldElement{value: 27, prime: 31}
    second = %FieldElement{value: 12, prime: 31}

    result = FieldElement.add(first, second)

    assert %FieldElement{value: 8, prime: 31} == result
  end

  test "sub works for valid field elements" do
    first = %FieldElement{value: 7, prime: 31}
    second = %FieldElement{value: 12, prime: 31}

    result = FieldElement.sub(first, second)

    assert %FieldElement{value: 5, prime: 31} == result
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

  test "combinatory methods raise error if primes don't match" do
    methods = [:add, :sub, :mul, :rmul]

    for method <- methods do
      first = %FieldElement{value: 27, prime: 32}
      second = %FieldElement{value: 12, prime: 31}

      assert_raise ArgumentError, fn ->
        apply(FieldElement, method, [first, second])
      end
    end
  end

end

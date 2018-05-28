defmodule Satoshi.Own.FieldElementTest do
  use ExUnit.Case, async: true

  alias Satoshi.Own.FieldElement

  test "add works for valid field elements" do
    first = %FieldElement{value: 27, prime: 31}
    second = %FieldElement{value: 12, prime: 31}

    result = FieldElement.add(first, second)

    assert %FieldElement{value: 8, prime: 31} == result
  end

  test "combinatory methods raise if primes don't match" do
    first = %FieldElement{value: 27, prime: 32}
    second = %FieldElement{value: 12, prime: 31}

    assert_raise ArgumentError, fn ->
      FieldElement.add(first, second)
    end
  end


end

defmodule Satoshi.Own.FieldElement do
  @moduledoc """
  Finite field element struct.
  """
  alias Satoshi.Util

  @prime Util.pow(2, 256) - Util.pow(2, 32) - 977

  @enforce_keys [:value, :prime]
  defstruct [:value, :prime]

  def new(value: value, prime: prime) do
    %__MODULE__{value: value, prime: prime}
  end

  def new_s256(value: value) do
    %__MODULE__{value: value, prime: @prime}
  end

  def add(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = val1 + val2
                |> rem(prime)

    %__MODULE__{value: new_value, prime: prime}
  end
  def add(%{value: val1, prime: prime}, val2) when is_integer(val2) do
    new_value = val1 + val2
                |> rem(prime)

    %__MODULE__{value: new_value, prime: prime}
  end
  def add(_, _), do: raise ArgumentError, "Parameters do not support point addition"

  def sub(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    sub_value = val1 - val2

    new_value =
      if sub_value < 0 do
        prime + sub_value
      else
        sub_value
        |> rem(prime)
        |> abs()
      end

    %__MODULE__{value: new_value, prime: prime}
  end
  def sub(_, _), do: raise ArgumentError, "Parameters do not support subtraction"

  def mul(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = val1 * val2
                |> rem(prime)
                |> abs()

    %__MODULE__{value: new_value, prime: prime}
  end
  def mul(_, _), do: raise ArgumentError, "Parameters do not support multiplication"


  def rmul(%{value: val1, prime: prime}, val2) when is_integer(val2) do
    new_value = val1 * val2
                |> rem(prime)
                |> abs()

    %__MODULE__{value: new_value, prime: prime}
  end
  def rmul(_, _), do: raise ArgumentError, "Parameters do not support real multiplication"

  def pow(%{value: val1, prime: prime}, val2) when is_integer(val2) do
    new_value =
      cond do
        val2 < 0 ->
          Util.pow(val1, prime - 1 + val2)
          |> rem(prime)
          |> abs()
        true ->
          Util.pow(val1, val2)
          |> round()
          |> rem(prime)
          |> abs()
      end

    %__MODULE__{value: new_value, prime: prime}
  end
  def pow(_, _), do: raise ArgumentError, "Paramets do not support power"

  def div(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = Util.powmod(val2, prime - 2, prime)
                |> Kernel.*(val1)
                |> rem(prime)
                |> abs()

    %__MODULE__{value: new_value, prime: prime}
  end
  def div(_, _), do: raise ArgumentError, "Parameters do not support division"
end

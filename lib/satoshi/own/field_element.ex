defmodule Satoshi.Own.FieldElement do
  @moduledoc """
  Finite field element struct.
  """

  @enforce_keys [:value, :prime]
  defstruct [:value, :prime]

  def add(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = val1 + val2
                |> rem(prime)

    %__MODULE__{value: new_value, prime: prime}
  end
  def add(_, _), do: raise ArgumentError

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
  def sub(_, _), do: raise ArgumentError

  def mul(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = val1 * val2
                |> rem(prime)
                |> abs()

    %__MODULE__{value: new_value, prime: prime}
  end
  def mul(_, _), do: raise ArgumentError

  def rmul(%{value: val1, prime: prime}, val2) when is_integer(val2) do
    new_value = val1 * val2
                |> rem(prime)
                |> abs()

    %__MODULE__{value: new_value, prime: prime}
  end
  def rmul(_, _), do: raise ArgumentError

  def pow(%{value: val1, prime: prime}, val2) when is_integer(val2) do
    new_value =
      cond do
        val2 < 0 ->
          my_pow(val1, prime - 1 + val2)
          |> rem(prime)
          |> abs()
        true ->
          my_pow(val1, val2)
          |> round()
          |> rem(prime)
          |> abs()
      end

    %__MODULE__{value: new_value, prime: prime}
  end
  def pow(_, _), do: raise ArgumentError

  def div(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = my_pow(val2, prime - 2)
                |> round()
                |> rem(prime)
                |> abs()
                |> Kernel.*(val1)
                |> rem(prime)
                |> abs()

    %__MODULE__{value: new_value, prime: prime}
  end
  def div(_, _), do: raise ArgumentError

  @doc ~S"""
  Implementation of the pow method with tail call optimization. Necessary since
  the Erlang native :math.pow/2 does not allow for high integer powers.

  ## Examples

      iex> Satoshi.Own.FieldElement.my_pow(17, 27)
      1667711322168688287513535727415473
  """
  def my_pow(n, k), do: my_pow(n, k, 1)
  defp my_pow(_, 0, acc), do: acc
  defp my_pow(n, k, acc), do: my_pow(n, k - 1, n * acc)
end

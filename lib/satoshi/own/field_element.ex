defmodule Satoshi.Own.FieldElement do
  @moduledoc """
  Finite field element struct.
  """

  @enforce_keys [:value, :prime]
  defstruct [:value, :prime]


  def add(%{value: val1, prime: prime}, %{value: val2, prime: prime}) do
    new_value = rem((val1 + val2), prime)

    %__MODULE__{value: new_value, prime: prime}
  end
  def add(_, _), do: raise ArgumentError
end
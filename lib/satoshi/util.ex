defmodule Satoshi.Util do
  @moduledoc """
  Shared functions/utilities for all other modules.
  """

  @doc ~S"""
  Hash a value with SHA256 twice.

  ## Examples

      iex> Satoshi.Util.double_sha256!('Hello World')
      <<66, 168, 115, 172, 58, 189, 2, 18, 45, 39, 232, 4, 134, 198, 250, 30, 247,
      134, 148, 232, 80, 95, 206, 201, 203, 204, 138, 119, 40, 186, 137, 73>>
  """
  @spec double_sha256!(binary) :: binary
  def double_sha256!(value) do
    :crypto.hash(:sha256, :crypto.hash(:sha256, value))
  end

  @doc ~S"""
  Hash a value with SHA256 and then RIPEMD160.

  ## Examples

      iex> Satoshi.Util.hash160!('Hello World')
      <<189, 251, 105, 85, 121, 102, 208, 38, 151, 91, 235, 233, 20, 105,
      43, 240, 132, 144, 216, 202>>
  """
  @spec hash160!(binary) :: binary
  def hash160!(value) do
    :crypto.hash(:ripemd160, :crypto.hash(:sha256, value))
  end

  @doc ~S"""
  Implementation of the pow method with tail call optimization. Necessary since
  the Erlang native :math.pow/2 does not allow for high integer powers.

  ## Examples

      iex> Satoshi.Util.my_pow(17, 27)
      1667711322168688287513535727415473
  """
  def my_pow(n, k), do: my_pow(n, k, 1)
  defp my_pow(_, 0, acc), do: acc
  defp my_pow(n, k, acc), do: my_pow(n, k - 1, n * acc)
end

defmodule Satoshi.Util do
  @moduledoc """
  Shared functions/utilities for all other modules.
  """

  @doc ~S"""
  Hash a value with SHA256 twice.

  ## Examples

      iex> Satoshi.Util.double_sha256('Hello World')
      <<66, 168, 115, 172, 58, 189, 2, 18, 45, 39, 232, 4, 134, 198, 250, 30, 247,
      134, 148, 232, 80, 95, 206, 201, 203, 204, 138, 119, 40, 186, 137, 73>>
  """
  @spec double_sha256(binary) :: binary
  def double_sha256(value) do
    :crypto.hash(:sha256, :crypto.hash(:sha256, value))
  end

end

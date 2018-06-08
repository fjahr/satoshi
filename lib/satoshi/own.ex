defmodule Satoshi.Own do
  import Integer

  alias Satoshi.Own.Point

  def my_sec(secret: s, compressed: compressed) do
    p = Point.rmul(Point.g(), s)
    x_binary = Integer.to_string(p.x.value, 16) |> String.downcase()
    y_binary = Integer.to_string(p.y.value, 16) |> String.downcase()

    address =
      if compressed do
        if is_even(p.y.value) do
          "02" <> x_binary
        else
          "03" <> x_binary
        end
      else
        "04" <> x_binary <> y_binary
      end

    Base.decode16!(address, case: :lower)
  end

end

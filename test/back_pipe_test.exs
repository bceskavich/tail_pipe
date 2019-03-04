defmodule TailPipeTest do
  use ExUnit.Case
  import TailPipe

  describe "~>/2" do
    test "It pipes the left-hand side into the last position of the right hand side function call" do
      assert 110 ~> Integer.digits() == [1, 1, 0]
    end

    test "It handles pipeline chains" do
      pipeline =
        100
        ~> Integer.digits()
        ~> Enum.concat([1, 2, 3])
        |> Enum.join("")
        ~> String.to_integer()

      assert pipeline == 123_100
    end
  end
end

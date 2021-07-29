defmodule SpaceCraftTest do
  @moduledoc """
    Tests of the SpaceCraft module.
  """
  use ExUnit.Case, async: true
  doctest SpaceCraft

  describe "moving/3" do
    test "returns and error if the commands its wrong from the selected area" do
      assert {:error, %SpaceCraft{x: 3, y: 4, direction: "S"},
              message: "The SpaceCraft is out of the selected area."}

      SpaceCraft.moving(%SpaceCraft{x: 2, y: 4, direction: "W"}, %{x: 5, y: 6}, [
        "L",
        "M",
        "M",
        "M",
        "M",
        "R"
      ])
    end

    test "show where the face of spacecraft is looking for" do
      assert %SpaceCraft{x: 12, y: 12, direction: "E"} ==
               SpaceCraft.moving(
                 %SpaceCraft{x: 10, y: 12, direction: "E"},
                 %{x: 15, y: 15},
                 ["M", "L", "R", "M"]
               )
    end
  end

  describe "run/1" do
    test "run to west in the Mars ground" do
      assert %SpaceCraft{x: 1, y: 5, direction: "W"} ==
               SpaceCraft.run(%SpaceCraft{x: 2, y: 5, direction: "W"})
    end
  end

  describe "locate/2" do
    test "returns an error if a wrong instruction is passed" do
      assert {:error, message: "This instruction is worng: j"} ==
               SpaceCraft.locate("j", %SpaceCraft{x: 3, y: 5, direction: "j"})
    end

    test "moving to right and give the face of the spacecraft is looking" do
      assert %SpaceCraft{x: 3, y: 5, direction: "N"} ==
               SpaceCraft.locate("R", %SpaceCraft{x: 3, y: 5, direction: "W"})
    end
  end
end

defmodule SpaceCraftTest do
  use ExUnit.Case
  doctest SpaceCraft

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

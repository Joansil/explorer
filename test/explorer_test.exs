defmodule ExplorerTest do
  @moduledoc """
    Tests of Explorer Module
  """
  use ExUnit.Case, async: true
  doctest Explorer

  describe "many_spcrafts/1" do
    test "returns an error when the wrong instructions is passed to spacecrafts" do
      assert [
               "Houston. We've had a problem. The eagle has landed out of the selected area. Because of this instructions: 1 20 N in the area %{x: 5, y: 5}",
               "5 1 E"
             ] ==
               Explorer.many_spcrafts([
                 ["5", "5"],
                 ["1", "20", "N"],
                 ["LMLMLMLMM"],
                 ["3", "3", "E"],
                 ["MMRMMRMRRM"]
               ])
    end

    test "set the area of landing" do
      assert ["0 2 N"] ==
               Explorer.many_spcrafts([["5", "5"], ["1", "2", "N"], ["LMR"]])
    end
  end

  describe "each_spcraft/2" do
    test "returns the face of the spacecraft looking for" do
      assert %SpaceCraft{x: 2, y: 3, direction: "W"} ==
               Explorer.each_spcraft([["3", "2", "N"], ["LMRML"]], %{x: 5, y: 5})
    end

    test "returns the error when the spacecraft is out of selected area" do
      assert {:error, %SpaceCraft{x: 2, y: 8, direction: "W"}, %{x: 5, y: 5},
              [
                message:
                  "Houston. We've had a problem. The eagle has landed out of the selected area."
              ]} ==
               Explorer.each_spcraft([["2", "8", "W"], ["LMRM"]], %{x: 5, y: 5})
    end
  end
end

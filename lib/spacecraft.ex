defmodule SpaceCraft do 

  @moduledoc """
    The module represent the spacecrafts sent to landing in Mars.
  """
  @enforce_keys [:x, :y, :direction]

  defstruct [:x, :y, :direction]

  @type t() :: %SpaceCraft{
          x: integer,
          y: integer,
          direction: String.t()
        }

  @doc """
  Instructions to locate the way to the spacecraft.

  ## Examples
      iex> SpaceCraft.locate("R", %SpaceCraft{x: 5, y: 2, direction: "N"})
      %SpaceCraft{direction: "E", x: 5, y: 2}

      iex> SpaceCraft.locate("j", %SpaceCraft{x: 5, y: 2, direction: "N"})
      {:error, [message: "This instruction is worng: j"]}
  """
  def locate(location, spcraft) when location in ["L", "R"] do
    way =
      %{
        "N" => %{"L" => "W", "R" => "E"},
        "S" => %{"L" => "E", "R" => "W"},
        "E" => %{"L" => "N", "R" => "S"},
        "W" => %{"L" => "S", "R" => "N"}
      }[spcraft.direction][location]

    %{spcraft | direction: way}
  end

  def locate(location, _), do: {:error, message: "This instruction is worng: #{location}"}

  defimpl String.Chars, for: SpaceCraft do
    @doc """
    Converts the spacecraft to a string

    ## Examples
        iex> to_string(%SpaceCraft{x: 7, y: 2, direction: "N"})
        "7 2 N"
    """
    def to_string(%SpaceCraft{x: x, y: y, direction: direction}),
      do: "#{x} #{y} #{direction}"
  end
end

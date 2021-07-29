defmodule SpaceCraft do
  require Logger

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
  The function LandingArea, put the spacecraft in the selected area in
  according with the list of commands, or returns and error.

  ## Examples
      iex> SpaceCraft.landing_area(%{x: 5, y: 5}, 1, 3, "N")
      {:ok, %SpaceCraft{direction: "N", x: 1, y: 3}}

      iex> SpaceCraft.landing_area(%{x: 5, y: 5}, 10, 43, "N")
      {:error, %SpaceCraft{direction: "N", x: 10, y: 43}, %{x: 5, y: 5},
       [
         message: "Houston. We've had a problem. The eagle has landed out of the selected area."
       ]}
  """
  def landing_area(%{x: x_border, y: y_border}, x, y, direction)
      when x in 0..x_border and y in 0..y_border and direction in ["N", "S", "E", "W"],
      do: {:ok, %SpaceCraft{x: x, y: y, direction: direction}}

  def landing_area(area, x, y, direction),
    do:
      {:error, %SpaceCraft{x: x, y: y, direction: direction}, area,
       message: "Houston. We've had a problem. The eagle has landed out of the selected area."}

  @doc """
    The function Moving recieve the list of command (strings) to moving in the selected area, and
    returns an error if the command put the spacecraft out of the selected area.

    ## Examples
    iex> SpaceCraft.moving(%SpaceCraft{x: 3, y: 1, direction: "S"}, %{x: 5, y: 5}, ["L","M","L","M", "L","M","L","M","M"])
    %SpaceCraft{direction: "S", x: 3, y: 0}

    iex> SpaceCraft.moving(%SpaceCraft{x: 3, y: 1, direction: "N"}, %{x: 5, y: 5}, ["M","M","R","M","M","M"])
    {:error, %SpaceCraft{direction: "E", x: 6, y: 3}, %{x: 5, y: 5},
    [message: "The SpaceCraft is out of the selected area."]}
  """

  def moving(spcraft, area = %{x: x_axis, y: y_axis}, command) do
    spcraft =
      Enum.reduce(command, spcraft, fn command, spcraft ->
        case(list_command(spcraft, command)) do
          {:error, message: message} ->
            Logger.error("Wrong command: #{message}")
            spcraft

          %SpaceCraft{} = load_spcraft ->
            load_spcraft
        end
      end)

    case spcraft do
      %SpaceCraft{x: x, y: y} when x > x_axis or y > y_axis ->
        {:error, spcraft, area, message: "The SpaceCraft is out of the selected area."}

      _ ->
        spcraft
    end
  end

  defp list_command(spcraft, command) when command == "M",
    do: run(spcraft)

  defp list_command(spcraft, command) when command in ["L", "R"],
    do: locate(command, spcraft)

  @doc """
  The function Run, move the spacecraft in the Mars ground.

  ## Examples
      iex> SpaceCraft.run(%SpaceCraft{x:  2, y: 4, direction: "W"})
      %SpaceCraft{direction: "W", x: 1, y: 4}
  """
  def run(spcraft) do
    case spcraft.direction do
      "N" -> %{spcraft | y: spcraft.y + 1}
      "S" -> %{spcraft | y: spcraft.y - 1}
      "E" -> %{spcraft | x: spcraft.x + 1}
      "W" -> %{spcraft | x: spcraft.x - 1}
    end
  end

  @doc """
  Instructions to locate the way to the spacecraft, like asked in challenge, following the
  cardinal points N S E W given the L (left) and R (right) orders.

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
    Its a protocol to converts the spacecraft tuple to a string.
    Its more "easy" when its will show the right datas to user, following the format asked in the
    in and out datas examples in the challenge.

    ## Examples
        iex> to_string(%SpaceCraft{x: 7, y: 2, direction: "N"})
        "7 2 N"
    """
    def to_string(%SpaceCraft{x: x, y: y, direction: direction}),
      do: "#{x} #{y} #{direction}"
  end
end

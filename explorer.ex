defmodule Explorer do
  require Logger

  @moduledoc """
  Documentation for `Explorer`.
  """

  @doc """
  The function EachSpcraft recieve a list of commands to the each spacecraft landing in Mars.
  If the commands its wrong, returns an error

  ## Examples
      iex> Explorer.each_spcraft([["4", "1", "N"], ["RMRM"]], %{x: 5, y: 5})
      %SpaceCraft{x: 5, y: 0, direction: "S"}

      iex> Explorer.each_spcraft([["7", "13", "W"], ["LMMLML"]], %{x: 5, y: 5})
      {:error, %SpaceCraft{direction: "W", x: 7, y: 13}, %{x: 5, y: 5},
       [
         message: "Houston. We've had a problem. The eagle has landed out of the selected area."
       ]}

      iex> Explorer.each_spcraft([["3", "3", "N"], ["MMMM"]], %{x: 5, y: 5})
      {:error, %SpaceCraft{direction: "N", x: 3, y: 7}, %{x: 5, y: 5},
       [message: "The SpaceCraft is out of the selected area."]}
  """
  def each_spcraft([[x_axis, y_axis, direction], [commands]], area) do
    case SpaceCraft.landing_area(
           area,
           String.to_integer(x_axis),
           String.to_integer(y_axis),
           direction
         ) do
      {:ok, spcraft} ->
        spcraft |> SpaceCraft.moving(area, String.split(commands, "", trim: true))

      error ->
        error
    end
  end

  @doc """
  This is the main function of the challenge.
  The function ManySpcrafts recieve a list of commands (list of strings) to the many spacecrafts
  landing in Mars.
  If one of this command its passed wrong, returns an error.
  In the example bellow, the datas of in and out, asked in the challenge, has been passed
  to the function.

  ## Examples
  iex> Explorer.many_spcrafts([["5", "5"], ["1", "2", "N"], ["LMLMLMLMM"], ["3", "3", "E"], ["MMRMMRMRRM"]])
  ["1 3 N", "5 1 E"]

  iex> Explorer.many_spcrafts([["5", "5"], ["1", "20", "N"], ["LMLMLMLMM"], ["3", "3", "E"], ["MMRMMRMRRM"]])
  ["Houston. We've had a problem. The eagle has landed out of the selected area. Because of this instructions: 1 20 N in the area %{x: 5, y: 5}",
  "5 1 E"]

  """
  def many_spcrafts([h | t]) do
    {:ok, area} = Kernel.apply(&set_area/2, Enum.map(h, &String.to_integer(&1)))

    t
    |> Enum.chunk_every(2)
    |> Enum.map(fn config_spcraft ->
      case each_spcraft(config_spcraft, area) do
        {:error, spcraft, area, [message: message]} ->
          Logger.error(
            "#{message} Because of this instructions: #{spcraft} in the area #{inspect(area)}"
          )

          "#{message} Because of this instructions: #{spcraft} in the area #{inspect(area)}"

        spcraft ->
          to_string(spcraft)
      end
    end)
  end

  @doc """
  The function SetArea, select the area with the values to the axis (x and y)
  from the spacecraft landing.
  Like asked in the challenge, the initial position is (0, 0).
  ## Examples

      iex> Explorer.set_area(5, 5)
      {:ok, %{x: 5, y: 5}}

      iex> Explorer.set_area(-5, -5)
      {:error, %{message: "The area can't be with negative values from the axis."}}
  """
  def set_area(x, y) when x > 0 and y > 0, do: {:ok, %{x: x, y: y}}

  def set_area(_, _),
    do: {:error, %{message: "The area can't be with negative values from the axis."}}
end

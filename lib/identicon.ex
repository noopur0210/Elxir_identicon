defmodule Identicon do
  #contains the pipeline for the whole project, takes a string as input
  def main(input) do
    input
    |>hash_input
    |>pick_color
    |>build_grid
  end

  #generates a ash value using the input string
  def hash_input(input) do

    #generating a hash value
    hex = :crypto.hash(:md5, input)
          |>:binary.bin_to_list

    #assigns the hash value as the hex struct property
    %Identicon.Image{hex: hex}
  end

  #generates the color using the list stored in struct as hex property
  def pick_color(image) do

  # another way of defining this function =>
  # `def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do`     <--- pattern-matching can be used directly in the arguments of the funtion

    #assigns the RGB values from the first three values of the hex property of struct
    %Identicon.Image{hex: [r, g, b | _tail]} = image

    #adds a tuple containing the RGB values into the struct as color property
    %Identicon.Image{image | color: {r, g, b}}
  end

  #generates a grid using the hex property and assigns color to the appropriate cells
  def build_grid(%Identicon.Image{hex: hex} = image) do     # using in-argument pattern-matching
    grid =
      hex
      |>Enum.chunk_every(3, 3, :discard)       #divides the hex list into list of sub-lists of size 3
      |>Enum.map(&mirror_row/1)         #takes the returned list and send each of is row to the referenced mirror_row function and creates a new list with each new row
      |>List.flatten
      |>Enum.with_index             #generates indices for each element of the grid

    #creating a new struct with the updated values
    %Identicon.Image{image | grid: grid}
  end

  #takes a row of the hex grid and mirrors it
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

end

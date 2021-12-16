defmodule Oscar.Board do

  def new( { width , height }, fill \\ " ") do
    List.duplicate(fill, width) |> List.duplicate(height)
  end

  def to_string(board) do
    board
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def from_string(s) do
    s |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  # remove trailing nils and replace remaining nils with " "
# defp line_to_string(line) do
#   {_, not_nil} = line
#   |> Enum.reverse
#   |> Enum.split_while(&is_nil/1)

#   not_nil
#   |> Enum.reverse
#   |> Enum.map(fn c -> if is_nil(c), do: " ", else: c end)
#   |> Enum.join("")
# end

  def width(board), do: Enum.at(board, 0, []) |> Enum.count()

  def height(board), do: Enum.count(board)

  def size(board), do: { width(board), height(board) }


  ## rect

  def add_rect(board, %{ x: x, y: y, width: width, height: height } = params ) do
    add_rect(board, { x, y }, { width, height }, params[:fill], params[:outline] )
  end

  def add_rect(board, _corner, _size, _fill, _outline \\ nil)

  # do nothing if neither fill nor outline is given
  def add_rect(board, _corner, _size, nil = _fill, nil = _outline)  do
    board
  end

  # no fill given
  def add_rect(board, corner, size, nil = _fill, outline)  do
    add_outline(board, corner, size, outline)
  end

  # no outline given
  def add_rect(board, corner, size, fill, nil = _outline)  do
    do_add_rect(board, corner, size, fill)
  end

  def add_rect(board, corner, size, fill, outline) do
    board
    |> do_add_rect(corner, size, fill)
    |> add_outline(corner, size, outline)
  end

  defp add_outline(board, { x, y }, { width, height }, c)  do
    board
    |> add_rect({ x,             y              }, { width, 1          }, c)
    |> add_rect({ x,             y + height - 1 }, { width, 1          }, c)
    |> add_rect({ x,             y + 1          }, { 1,     height - 2 }, c)
    |> add_rect({ x + width - 1, y + 1          }, { 1,     height - 2 }, c)
  end

  def do_add_rect(board, { x, y }, { width, height }, char) when is_binary(char) and width > 0 and height > 0 and x >= 0 and y >= 0 do
    for x <- (x..x + width - 1), y <- (y..y + height - 1) do
      { x, y }
    end
    |> set_points(board, char)
  end

  def do_add_rect(board, _point, _size, _char), do: board

  ## flood

  def add_flood(board, %{x: x, y: y, fill: fill}) do
    add_flood(board, { x, y }, fill)
  end

  def add_flood(board, { x, y } = point, char) when x >= 0 and y >= 0 and is_binary(char) do
    to_be_flooded(board, point, MapSet.new([point]))
    |> IO.inspect(label: "ADD FLOOD")
    |> set_points(board, char)
  end

  def add_flood(board, _point, _char), do: board

  # private

  defp to_be_flooded(board, point, found) do
#   found |> IO.inspect(label: "\nFOUND")
    char = get_char(board, point)
#   |> IO.inspect(label: "CHAR")

    neighbours_ = point
#   |> IO.inspect(label: "POINT")
    |> neighbours()
#   |> IO.inspect(label: "NB")
    |> Enum.filter(fn p ->
      !MapSet.member?(found, p)
      && get_char(board, p) == char
      && on_board?(board, p)
    end)
    |> Enum.reduce(found, fn nb, f -> MapSet.put(f, nb) end)
    |> IO.inspect(label: "FILTERED")
    |> Enum.flat_map(&to_be_flooded(board, &1, found ))
    |> MapSet.new()
#   |> IO.inspect(label: "NEIGHBORS ->")
    MapSet.put(neighbours_ , point)
  end

  defp set_points(points, board, char) do
     points |> Enum.reduce(board, fn p, board_ -> set_char(board_, p, char) end)
  end

  defp neighbours({ x, y }) do
    [{ x-1, y }, { x+1, y }, { x, y-1 }, { x, y+1 }]
  end

  defp get_char(board, { x, y }, default \\ nil) do
    board |> Enum.at(y, []) |> Enum.at(x, default)
  end

  def set_char(board, { x, y }, c) do
    List.update_at(board, y, &List.replace_at(&1, x, c))
  end

  defp on_board?(board, { x, y } ) do
    0 <= x && x < width(board) && 0 <= y && y < height(board)
  end

end

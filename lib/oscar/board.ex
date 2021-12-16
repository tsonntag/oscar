defmodule Oscar.Board do

  def new( { width , height }, fill \\ nil) do
    List.duplicate(fill, width) |> List.duplicate(height)
  end

  def to_string(board) do
    board
    |> Enum.map(fn line -> line_to_string(line) <> "\n" end)
    |> Enum.join("")
  end

  def from_string(s) do
    s |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  # remove trailing nils and replace remaining nils with " "
  defp line_to_string(line) do
    {_, not_nil} = line
    |> Enum.reverse
    |> Enum.split_while(&is_nil/1)

    not_nil
    |> Enum.reverse
    |> Enum.map(fn c -> if is_nil(c), do: " ", else: c end)
    |> Enum.join("")
  end

  def width(board), do: Enum.at(board, 0, []) |> Enum.count()

  def height(board), do: Enum.count(board)

  def size(board), do: { width(board), height(board) }


  ## rect

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
    |> Enum.reduce(board, fn p, board_ -> set_char(board_, p, char) end)
  end

  def do_add_rect(board, _point, _size, _char), do: board

  ## flood

  def add_flood(board, point, new_char) do
    do_add_flood(board, point, get_char(board, point), new_char)
  end

  defp do_add_flood(board, { x, y } = point, old_char, new_char) when x >= 0 and y >= 0 do
    board
    |> neighbours_on_board(point)
    |> Enum.filter(fn p ->
      get_char(board, p) == old_char 
    end)
    |> Enum.reduce(board, fn neighbour, board_ ->
      board_
      |> set_char(neighbour, new_char)
      |> do_add_flood(neighbour, old_char, new_char)
    end)
  end

  defp do_add_flood(board, _point, _old_char, _new_char), do: board

  # private

  defp neighbours_on_board(board, { x, y }) do
    [{ x-1, y }, { x+1, y }, { x, y-1 }, { x, y+1 }]
    |> Enum.filter(&on_board?(board, &1))
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

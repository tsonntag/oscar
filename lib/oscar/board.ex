defmodule Oscar.Board do
  alias Oscar.Board

  def new( width, height, fill \\ " ") do
    List.duplicate(fill,width) |> List.duplicate(height)
  end

  def to_string(board, default \\ nil) do
    board |> lines() |> Enum.join("\n")
  end

  def from_string(s) do
    s |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  def lines(board), do: board |> Enum.map(&Kernel.to_string/1)

  def width(board), do: Enum.at(board, 0, []) |> Enum.count()

  def height(board), do: Enum.count(board)

  def size(board), do: {width(board), height(board)}


  ## rect

  def add_rect(board, {x, y}, { width, height}, c) when is_binary(c) do
    for x <- (x..x + width - 1), y <- (y..y + height - 1) do
      {x,y}
    end
    |> Enum.reduce(board, fn p, f -> set_char(f, p, c) end)
  end

  def add_rect(board, _corner, _size, nil = _outline, nil = _fill)  do
    board
  end

  def add_rect(board, corner, size, nil = _outline, fill)  do
    add_rect(board, corner, size, fill)
  end

  def add_rect(board, {x, y} = corner, {width, height} = size, outline, fill) when is_binary(fill) and width > 2 and height > 2 do
    board
    |> add_outline(corner, size, outline)
    |> add_rect({x + 1, y + 1}, {width - 2, height - 2}, fill)
  end

  def add_rect(board, corner, size, outline, _fill)  do
    add_outline(board, corner, size, outline)
  end

  defp add_outline(board, {x,y}, {width, height}, c)  do
    board
    |> add_rect({ x,             y              }, { width, 1          }, c)
    |> add_rect({ x,             y + height - 1 }, { width, 1          }, c)
    |> add_rect({ x,             y + 1          }, { 1,     height - 1 }, c)
    |> add_rect({ x + width - 1, y + 1          }, { 1,     height - 1 }, c)
  end

  ## flood

  def add_flood(board, point, fill) do
    do_add_flood(board, point, get_char(board, point), fill)
  end

  defp do_add_flood(board, point, match_char, fill) do
    board
    |> matching_neighbours(point, match_char)
    |> Enum.reduce(board, fn neighbour, f ->
      f
      |> set_char(neighbour, fill)
      |> do_add_flood(neighbour, match_char, fill)
    end)
  end


  def dump(board, default \\ nil) do
    xmargin = for(i <- (0..width(board)-1), do: Kernel.to_string(i))
    ymargin   = for(i <- (0..height(board)-1), do: Kernel.to_string(i)) 
    margin = "|" <> Enum.join(xmargin,"") <> "|"
    IO.puts(margin)
    Enum.zip(ymargin,lines(board)) |> Enum.map(fn {y,line} -> IO.puts(y <> line <> y) end)
    IO.puts margin
  end

  # private

  defp neighbours({x, y}) do
    [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
  end

  defp matching_neighbours(board, point, match_char) do
    neighbours(point) |> Enum.filter(fn p -> on_board?(board, p) && match_char == get_char(board, p) end)
  end

  defp get_char(board, {x,y}, default \\ nil) do
    board |> Enum.at(y, []) |> Enum.at(x, default)
  end

  defp set_char(board, {x,y}, c) do
    List.update_at(board, y, &List.replace_at(&1,x, c))
  end
 
  defp on_board?(board, {x,y} ) do
    0 <= x && x < width(board) && 0 <= y && y < height(board)
  end

end

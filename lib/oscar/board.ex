defmodule Oscar.Board do

  def new (%{ width: width, height: height } = args ) do
    fill = Map.get(args, :fill, " ")
    List.duplicate(fill, width) |> List.duplicate(height)
  end

  def new({width, height}, fill \\ " ") do
    new(%{ width: width, height: height, fill: fill })
  end

  def to_string(board) do
    board
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def from_string(s) do
    s |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

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
    flood(board, point, get_char(board, point), char)
  end

  def add_flood(board, _point, _char), do: board

  # private

  defp flood(board, point, old_char, new_char, done \\ MapSet.new()) do
    board = board |> set_char(point, new_char)
    done = MapSet.put(done, point)

    point
    |> neighbours()
    |> Enum.filter(fn p -> on_board?(board, p) && get_char(board, p) == old_char  && !MapSet.member?(done, p)end)
    |> Enum.reduce(board, fn p, board_ -> flood(board_, p, old_char, new_char, done) end)
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

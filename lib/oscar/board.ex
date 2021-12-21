defmodule Oscar.Board do
  @moduledoc ~S"""
  ### Boards

  A board is a two dimensional array of characters.
  It is implemented as list of list of strings

  This module implements the API to create boards
  and to add rectangulars and 'floods'.

  ### Drawing operations

  - Drawing operations are applied to the canvas in the same order that they are passed in to the server.

  """

  @doc """
  Returns a board of width, height optional fill character (default is " ")

  ## Example

    iex> new(%|width: 3, height: 2, fill: "X")
    [["X", "X", "X"], ["X", "X", "X"]]

    iex> new({3, 2}, "X")
    [["X", "X", "X"], ["X", "X", "X"]]
  """
  def new(%{ width: width, height: height } = args) do
    fill = Map.get(args, :fill, " ")
    List.duplicate(fill, width) |> List.duplicate(height)
  end

  def new({width, height}, fill \\ " ") do
    new(%{ width: width, height: height, fill: fill })
  end

  @doc """
  Returns an 'ASCII art' string

   ## Example
   iex> new({3, 2}, "X") |> to_content()
   "XXX\nXXX"
  """
  def to_content(board) do
    board
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  @doc """
  Creates a board from an 'ASCII art' string

    ## Example
    iex> "XXX\nYYY" |> from_content()
    [["X", "X", "X"], ["Y", "Y", "Y"]]
  """
  def from_content(s) do
    s |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  @doc """
  Returns the width of a board
  """
  def width(board), do: Enum.at(board, 0, []) |> Enum.count()

  @doc """
  Returns the height of a board
  """
  def height(board), do: Enum.count(board)

  @doc """
  Adds a rectangle with parameters x, y, width, height, fill character and outline character to a board
  - x, y denote to upper-left corner
  - One of either **fill** or **outline** should always be present.

  One or either fill or outline must be given

    ## Examples

    iex> new({3,4},".") |> add_rect(, %{ x: 0, y: 0, width: 3, height: 3, outline: "O", fill: "X" }  |> to_content()
    "OOO\nOXO\nOOO\n..."

    iex> new({3,4},".") |> add_rect(, %{ x: 0, y: 0, width: 1, height: 2, fill: "X" }  |> to_content()
    "X..\nX..\n...\n..."

    Conveniance function:
    add_rect(x, y, width, height, fill, outline)
  """
  def add_rect(board, %{ x: x, y: y, width: width, height: height } = params) do
    add_rect(board, { x, y }, { width, height }, params[:fill], params[:outline])
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

  defp do_add_rect(board, { x, y }, { width, height }, char) when is_binary(char) and width > 0 and height > 0 and x >= 0 and y >= 0 do
    for x <- (x..x + width - 1), y <- (y..y + height - 1) do
      { x, y }
    end
    |> set_points(board, char)
  end

  defp do_add_rect(board, _point, _size, _char), do: board


  @doc """
  A flood fill operation, parameterised with
  - the **start coordinates** x, y from where to begin the flood fill.
  - a **fill** character.

  A flood fill operation draws the fill character to the start coordinate, and continues to attempt drawing the character around (up, down, left, right) in each direction from the position it was drawn at, as long as a different character, or a border of the canvas, is not reached.

    ## Examples

    iex> "XXX\nX..\n..." |> from_content() |> flood_fill(, %{ x: 1, y: 0, fill: "-" }  |> to_content()
    "XXX\nX--\n---"

  Conveniance function:
  flood_fill({x,y}, fill)
  """
  def flood_fill(board, %{x: x, y: y, fill: fill}) do
    flood_fill(board, { x, y }, fill)
  end

  def flood_fill(board, { x, y } = point, char) when x >= 0 and y >= 0 and is_binary(char) do
    do_flood_fill(board, point, get_char(board, point), char)
  end

  def flood_fill(board, _point, _char), do: board


  # private stuff

  defp do_flood_fill(board, point, old_char, new_char, done \\ MapSet.new()) do
    board = board |> set_char(point, new_char)
    done = MapSet.put(done, point)

    point
    |> neighbours()
    |> Enum.filter(fn p -> on_board?(board, p) && get_char(board, p) == old_char && !MapSet.member?(done, p) end)
    |> Enum.reduce(board, fn p, board_ -> do_flood_fill(board_, p, old_char, new_char, done) end)
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

  defp set_char(board, { x, y }, c) do
    List.update_at(board, y, &List.replace_at(&1, x, c))
  end

  defp on_board?(board, { x, y }) do
    0 <= x && x < width(board) && 0 <= y && y < height(board)
  end

end

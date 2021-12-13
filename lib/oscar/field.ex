defmodule Oscar.Field do
  defstruct size: {1, 1}, chars: %{}


  alias Oscar.Field
  import Oscar.Utils, only: [deep_merge: 2]

  def new( width, height) do
    %Field{size: {width, height}, chars: %{}}
  end

  def add_rect(%Field{} = field, {x0, y0}, { xlen, ylen}, c) when is_binary(c) do
    for x <- (x0..x0 + xlen - 1), y <- (y0..y0 + ylen - 1) do
      {x,y}
    end
    |> Enum.reduce(field, fn {x,y}, f ->
      deep_merge(f, %{ chars: %{x => %{ y => c}}})
    end)
  end

  def add_rect(%Field{} = field, _corner, _size, nil = _outline, nil = _fill)  do
    field
  end

  def add_rect(%Field{} = field, corner, size, nil = _outline, fill)  do
    add_rect(field, corner, size, fill)
  end

  def add_rect(%Field{} = field, {x0, y0} = corner, {xlen, ylen} = size, outline, fill) when is_binary(fill) and xlen > 2 and ylen > 2 do
    field
    |> add_outline(corner, size, outline)
    |> add_rect({x0 + 1, y0 + 1}, {xlen - 2, ylen - 2}, fill)
  end

  def add_rect(%Field{} = field, corner, size, outline, _fill)  do
    add_outline(field, corner, size, outline)
  end

  def add_flood(%Field{} = field, point, fill) do
    field
    |> empty_neighbours(point)
    |> Enum.reduce(field, fn neighbour, f ->
      f |> add_rect(neighbour, {1,1}, fill) |> add_flood(neighbour, fill)
    end)
  end

  def add_outline(%Field{} = field, {x0,y0}, {xlen, ylen}, c)  do
    field
    |> add_rect({ x0,            y0            }, { xlen, 1        }, c)
    |> add_rect({ x0,            y0 + ylen - 1 }, { xlen, 1        }, c)
    |> add_rect({ x0,            y0 + 1        }, { 1,    ylen - 1 }, c)
    |> add_rect({ x0 + xlen - 1, y0 + 1        }, { 1,    ylen - 1 }, c)
  end

  def to_array(%Field{size: {xlen, ylen}} = field, default \\ " ") do
    for y <- (0..ylen - 1) do
      for x <- (0..xlen - 1) do
        get_char(field, {x, y}, default)
      end
    end
  end

  def has_point?({xlen, ylen}, {x,y} ) do
    Enum.member?((0..xlen-1), x) && Enum.member?((0..ylen-1), y)
  end

  def get_char(%Field{chars: chars}, {x,y}, default \\ nil) do
    chars |> Map.get(x, %{}) |> Map.get(y, default)
  end

  def neighbours({x, y}) do
    [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
  end

  def empty_neighbours(%Field{size: size} = field, point) do
    neighbours(point) |> Enum.filter(fn p -> has_point?(size, p) && is_nil(get_char(field, p)) end)
  end
end

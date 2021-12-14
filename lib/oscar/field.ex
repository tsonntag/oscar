defmodule Oscar.Field do
  defstruct size: {1, 1}, chars: %{}

  alias Oscar.Field
  import Oscar.Utils, only: [deep_merge: 2]

  def new( width, height) do
    %Field{size: {width, height}, chars: %{}}
  end

  def add_rect(%Field{} = field, {x, y}, { width, height}, c) when is_binary(c) do
    for x <- (x..x + width - 1), y <- (y..y + height - 1) do
      {x,y}
    end
    |> Enum.reduce(field, fn p, f -> set_char(f, p, c) end)
  end

  def add_rect(%Field{} = field, _corner, _size, nil = _outline, nil = _fill)  do
    field
  end

  def add_rect(%Field{} = field, corner, size, nil = _outline, fill)  do
    add_rect(field, corner, size, fill)
  end

  def add_rect(%Field{} = field, {x, y} = corner, {width, height} = size, outline, fill) when is_binary(fill) and width > 2 and height > 2 do
    field
    |> add_outline(corner, size, outline)
    |> add_rect({x + 1, y + 1}, {width - 2, height - 2}, fill)
  end

  def add_rect(%Field{} = field, corner, size, outline, _fill)  do
    add_outline(field, corner, size, outline)
  end

  def add_flood(%Field{} = field, point, fill) do
    do_add_flood(field, point, get_char(field, point), fill)
  end

  defp do_add_flood(%Field{} = field, point, match_char, fill) do
    field
    |> matching_neighbours(point, match_char)
    |> Enum.reduce(field, fn neighbour, f ->
      f
      |> set_char(neighbour, fill)
      |> do_add_flood(neighbour, match_char, fill)
    end)
  end

  defp add_outline(%Field{} = field, {x,y}, {width, height}, c)  do
    field
    |> add_rect({ x,             y              }, { width, 1          }, c)
    |> add_rect({ x,             y + height - 1 }, { width, 1          }, c)
    |> add_rect({ x,             y + 1          }, { 1,     height - 1 }, c)
    |> add_rect({ x + width - 1, y + 1          }, { 1,     height - 1 }, c)
  end

  def to_array(%Field{size: {width, height}} = field, default \\ nil) do
    for y <- (0..height - 1) do
      for x <- (0..width - 1) do
        get_char(field, {x, y}, default)
      end
    end
  end

  defp has_point?({width, height}, {x,y} ) do
    Enum.member?((0..width-1), x) && Enum.member?((0..height-1), y)
  end

  defp get_char(%Field{chars: chars}, {x,y}, default \\ nil) do
    chars |> Map.get(x, %{}) |> Map.get(y, default)
  end

  defp neighbours({x, y}) do
    [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
  end

  defp matching_neighbours(%Field{size: size} = field, point, match_char) do
    neighbours(point) |> Enum.filter(fn p -> has_point?(size, p) && match_char == get_char(field, p) end)
  end

  defp set_char(%Field{} = field, {x,y}, c) do
    deep_merge(field, %{ chars: %{x => %{ y => c}}})
  end
 

end

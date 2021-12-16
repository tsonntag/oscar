defmodule Oscar.Canvas do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Oscar.{Repo, Canvas, Board}

  import String, only: [to_integer: 1]


  schema "canvases" do
    field :content, :string
    field :name, :string

    timestamps()
  end

  def board(%Canvas{content: content}), do: Board.from_string(content)

  def size(canvas), do: canvas |> board() |> Board.size()

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:name, :content])
    |> validate_required([:name])
  end



  @doc """
  Returns the list of canvases.

  ## Examples

      iex> list()
      [%Canvas{}, ...]

  """
  def list do
    Repo.all(Canvas) |> IO.inspect
  end

  @doc """
  Gets a single canvas.

  Raises `Ecto.NoResultsError` if the Canvas does not exist.

  ## Examples

      iex> get!(123)
      %Canvas{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Canvas, id)

  @doc """
  Creates a canvas with name, width, height and an optional fill character.

  ## Examples

  iex> new(canvas, %{"name" => "foo", "width" => 2, height; 3, "fill" => "F"})
     %Canvas{name: "foo", content: "FF\nFF\nFF"}
  """
  def new(%{"name" =>  name, "width" =>  width, "height" => height} = params) do
    fill = Map.get(params, "fill", " ")
    fill = if String.length(fill) == 1, do: fill, else: " "

    content = Board.new({to_integer(width), to_integer(height)}, fill)
    |> Board.to_string
    %Canvas{ name: name, content: content }
  end


  @doc """
  Creates a canvas with name and content

  ## Examples

      iex> create_rect(canvas, %{"name" =>  name, "width" =>  width, height; height, "fill" => fill})
      {:ok, %Canvas{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Canvas{}
    |> Canvas.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:canvas_created)
  end


  @doc """
  Adds rectangle with upper left corner x, y and width and heigth to a canvas.

  ## Examples

  iex> add_rect(canvas, %{"x" => x, y; y, "width" =>  width, "height" => height, "fill" => fill, "outline" => outline})
  {:ok, %Canvas{}}
  """
  def add_rect(%Canvas{content: content} = canvas, %{"x" => x, "y" => y, "width" =>  width, "height" => height, "fill" => fill, "outline" => outline}) do
    content = content
    |> Board.from_string()
    |> Board.add_rect({to_integer(x), to_integer(y)}, {to_integer(width), to_integer(height)}, fill, outline)
    |> Board.to_string()

    attrs = %{ content: content}
    canvas
    |> Canvas.update(attrs)
  end

  @doc """
  Adds flood to a canvas.

  ## Examples

  iex> add_flood(canvas, %{"x" => x, y; y, "fill" => fill})
  {:ok, %Canvas{}}
  """
  def add_flood(%Canvas{content: content} = canvas, %{"x" => x, "y" => y, "fill" => fill} ) do
    content = content
    |> Board.from_string()
    |> Board.add_flood({to_integer(x), to_integer(y)}, fill)
    |> Board.to_string()

    attrs = %{ content: content}
    canvas
    |> Canvas.update(attrs)
  end

  @doc """
  Updates a canvas.

  ## Examples

      iex> update(canvas, %{field: new_value})
      {:ok, %Canvas{}}

      iex> update(canvas, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Canvas{} = canvas, attrs) do
    canvas
    |> Canvas.changeset(attrs)
    |> Repo.update()
    |> broadcast(:canvas_updated)
  end

  @doc """
  Deletes a canvas.

  ## Examples

      iex> delete(canvas)
      {:ok, %Canvas{}}

      iex> delete(canvas)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Canvas{} = canvas) do
    Repo.delete(canvas)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking canvas changes.

  ## Examples

      iex> change(canvas)
      %Ecto.Changeset{data: %Canvas{}}

  """
  def change(%Canvas{} = canvas, attrs \\ %{}) do
    Canvas.changeset(canvas, attrs)
  end


  def subscribe do
    Phoenix.PubSub.subscribe(Oscar.PubSub, "canvases")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, canvas}, event) do
    Phoenix.PubSub.broadcast(Oscar.PubSub, "canvases", {event, canvas})
    {:ok, canvas}
  end
end

defmodule Oscar.Canvas do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Oscar.{Repo, Canvas, Board}

  import String, only: [to_integer: 1]


  schema "canvases" do
    field :content, :string

    timestamps()
  end

  def board(%Canvas{content: content}), do: Board.from_string(content)

  def size(canvas), do: canvas |> board() |> Board.size()

  def to_string(%Canvas{content: content}), do: Board.to_string(content)

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:content])
  end

  @doc false
  def rect_changeset( attrs) do
    types = %{x: :integer, y: :integer, width: :integer, height: :integer, fill: :string, outline: :string}
    data = %{}
    cast({data, types}, attrs, [:x, :y, :width, :height, :fill, :outline])
  end

  @doc false
  def flood_changeset( attrs) do
    types = %{x: :integer, y: :integer, fill: :string}
    data = %{}
    cast({data, types}, attrs, [:x, :y, :fill])
  end


  @doc """
  Returns the list of canvases.

  ## Examples

      iex> list()
      [%Canvas{}, ...]

  """
  def list do
    Repo.all(Canvas)
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
  Creates a canvas with width, height and an optional fill character.

  ## Examples

  iex> new(canvas, %{"width" => 2, height; 3, "fill" => "F"})
     %Canvas{content: "FF\nFF\nFF"}
  """
  def new(%{"width" =>  width, "height" => height} = attrs) do
    fill = Map.get(attrs, "fill", " ")
    fill = if String.length(fill) == 1, do: fill, else: " "

    content = Board.new({to_integer(width), to_integer(height)}, fill)
    |> Board.to_string

    %Canvas{content: content }
  end


  @doc """
  Creates a canvas with content

  ## Examples

      iex> create_rect(canvas, %{"width" =>  width, height; height, "fill" => fill})
      {:ok, %Canvas{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    attrs
    |> new()
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
  def add_rect(%Canvas{content: content} = canvas, params) do 
    rect_params = params |> rect_changeset() |> apply_changes()

    content = content
    |> Board.from_string()
    |> IO.inspect(label: "FROM")
    |> Board.add_rect(rect_params)
    |> IO.inspect(label: "RECT")
    |> Board.to_string()
    |> IO.inspect(label: "TO")

    canvas
    |> Canvas.update(%{ content: content})
  end

  @doc """
  Adds flood to a canvas.

  ## Examples

  iex> add_flood(canvas, %{"x" => x, "y" => y, "fill" => fill})
  {:ok, %Canvas{}}
  """
  def add_flood(%Canvas{content: content} = canvas, params) do
    flood_params = params |> flood_changeset() |> apply_changes()

    content = content
    |> Board.from_string()
    |> Board.add_flood(flood_params)
    |> Board.to_string()

    canvas
    |> Canvas.update(%{ content: content })
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
    |> changeset(attrs)
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
    |> broadcast(:canvas_deleted)
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

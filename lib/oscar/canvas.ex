defmodule Oscar.Canvas do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Oscar.{Repo, Canvas, Board}

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
    |> cast(attrs, [:content], empty_values: [nil] )
    |> validate_not_nil([:content])
  end

  @doc false
  def changeset_for_new(attrs) do
    types = %{width: :integer, height: :integer, fill: :string}
    data = %{}
    cast({data, types}, attrs, [:width, :height, :fill])
    |> validate_required([:width, :height])
    |> validate_length(:fill, is: 1)
  end

  @doc false
  defp changeset_for_add_flood( attrs) do
    types = %{x: :integer, y: :integer, fill: :string}
    data = %{}
    cast({data, types}, attrs, [:x, :y, :fill])
    |> validate_required([:x, :y, :fill])
    |> validate_length(:fill, is: 1)
  end

  @doc false
  defp changeset_for_add_rect( attrs) do
    types = %{x: :integer, y: :integer, width: :integer, height: :integer, fill: :string, outline: :string}
    data = %{}
    cast({data, types}, attrs, [:x, :y, :width, :height, :fill, :outline])
    |> validate_required([:x, :y, :width, :height])
    |> validate_or([:fill , :outline])
    |> validate_length(:outline, is: 1)
    |> validate_length(:fill, is: 1)
  end

  @doc false
  defp validate_or(changeset, fields) do
    if Enum.any?(fields, &get_field(changeset, &1)) do
      changeset
    else
      fields |> Enum.reduce(changeset, fn field, changeset ->
        add_error(changeset, field, "One of these fields must be present: #{inspect fields}")
      end)
    end
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
  Creates a canvas from width and height 

  ## Examples

      iex> create_rect(canvas, %{"width" =>  2, height; 3, "fill" => "F})
      {:ok, %Canvas{content: "FF\nFF\nFF"}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    cs = changeset_for_new(attrs)
    if cs.valid? do
      content = cs |> apply_changes() |> Board.new() |> Board.to_string() 
      create_content(%{content: content})
     else
       { :error, cs }
    end
  end

  @doc """
  Creates a canvas with content

  ## Examples

  iex> create_rect(canvas, %{"content" => "AA"})
  {:ok, %Canvas{content: "AA"}}

  iex> create(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_content(attrs \\ %{}) do
    Canvas.changeset(%Canvas{}, attrs)
    |> Repo.insert()
    |> broadcast(:canvas_created)
  end


  @doc """
  Adds rectangle with upper left corner x, y and width and heigth to a canvas.

  ## Examples

  iex> add_rect(canvas, %{"x" => x, "y" => y, "width" =>  width, "height" => height, "fill" => fill, "outline" => outline})
  {:ok, %Canvas{}}
  """
  def add_rect(%Canvas{content: content} = canvas, attrs) do 
    cs = changeset_for_add_rect(attrs)

    if cs.valid? do
      content = content
      |> Board.from_string()
      |> Board.add_rect(apply_changes(cs))
      |> Board.to_string()

      Canvas.update(canvas, %{content: content})
    else
      { :error, cs }
    end
  end

  @doc """
  Adds flood to a canvas.

  ## Examples

  iex> add_flood(canvas, %{"x" => x, "y" => y, "fill" => fill})
  {:ok, %Canvas{}}
  """
  def add_flood(%Canvas{content: content} = canvas, attrs) do
    cs = changeset_for_add_flood(attrs)

    if cs.valid? do
      content = content
      |> Board.from_string()
      |> Board.add_flood(apply_changes(cs))
      |> Board.to_string()

      Canvas.update(canvas, %{content: content})
    else
      { :error, cs }
    end
  end

  @doc false
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


  defp validate_not_nil(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      if get_field(changeset, field) == nil do
        add_error(changeset, field, "nil")
      else
        changeset
      end
    end)
  end
end

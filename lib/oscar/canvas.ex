defmodule Oscar.Canvas do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Oscar.{Repo, Canvas}


  schema "canvases" do
    field :content, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
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
  Creates a canvas.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Canvas{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Canvas{}
    |> Canvas.changeset(attrs)
    |> Repo.insert()
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

end

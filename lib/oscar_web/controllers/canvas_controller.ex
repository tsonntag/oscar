defmodule OscarWeb.CanvasController do
  use OscarWeb, :controller

  alias Oscar.Canvas

  action_fallback OscarWeb.FallbackController

  def index(conn, _params) do
    canvases = Canvas.list()
    render(conn, "index.json", canvases: canvases)
  end

  @doc """
  Creates a canvas.

  See Oscar.Canvas.create for params

  """
  def create(conn, %{"canvas" => params}) do
    with {:ok, %Canvas{} = canvas} <- Canvas.create(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.canvas_path(conn, :show, canvas))
      |> render("show.json", canvas: canvas)
    end
  end

  @doc """
  Shows canvas with given id
  """
  def show(conn, %{"id" => id}) do
    canvas = Canvas.get!(id)
    render(conn, "show.json", canvas: canvas)
  end

  @doc """
  Adds a rectangular to a canvas.

  See Oscar.Canvas.add_rect for params
  """

  def add_rect(conn, %{"id" => id, "canvas" => params}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{} = canvas} <- Canvas.add_rect(canvas, params) do
      render(conn, "show.json", canvas: canvas)
    end
  end

  @doc """
  Adds a flood to a canvas.

  See Oscar.Canvas.add_flood for params
  """

  def add_flood(conn, %{"id" => id, "canvas" => params}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{} = canvas} <- Canvas.add_flood(canvas, params) do
      render(conn, "show.json", canvas: canvas)
    end
  end


  @doc """
  Deletes a canvas.
  """
  def delete(conn, %{"id" => id}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{}} <- Canvas.delete(canvas) do
      send_resp(conn, :no_content, "")
    end
  end
end

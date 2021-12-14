defmodule OscarWeb.CanvasController do
  use OscarWeb, :controller

  alias Oscar.Canvas

  action_fallback OscarWeb.FallbackController

  def index(conn, _params) do
    canvases = Canvas.list()
    render(conn, "index.json", canvases: canvases)
  end

  def create(conn, %{"canvas" => canvas_params}) do
    IO.inspect canvas_params
    with {:ok, %Canvas{} = canvas} <- Canvas.create(canvas_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.canvas_path(conn, :show, canvas))
      |> render("show.json", canvas: canvas)
    end
  end

  def show(conn, %{"id" => id}) do
    canvas = Canvas.get!(id)
    render(conn, "show.json", canvas: canvas)
  end

  def update(conn, %{"id" => id, "canvas" => canvas_params}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{} = canvas} <- Canvas.update(canvas, canvas_params) do
      render(conn, "show.json", canvas: canvas)
    end
  end

  def add_rect(conn, %{"id" => id, "canvas" => canvas_params}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{} = canvas} <- Canvas.add_rect(canvas, canvas_params) do
      render(conn, "show.json", canvas: canvas)
    end
  end

  def add_flood(conn, %{"id" => id, "canvas" => canvas_params}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{} = canvas} <- Canvas.add_flood(canvas, canvas_params) do
      render(conn, "show.json", canvas: canvas)
    end
  end

  def delete(conn, %{"id" => id}) do
    canvas = Canvas.get!(id)

    with {:ok, %Canvas{}} <- Canvas.delete(canvas) do
      send_resp(conn, :no_content, "")
    end
  end
end

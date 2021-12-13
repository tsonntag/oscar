defmodule OscarWeb.CanvasView do
  use OscarWeb, :view
  alias OscarWeb.CanvasView

  def render("index.json", %{canvases: canvases}) do
    %{data: render_many(canvases, CanvasView, "canvas.json")}
  end

  def render("show.json", %{canvas: canvas}) do
    %{data: render_one(canvas, CanvasView, "canvas.json")}
  end

  def render("canvas.json", %{canvas: canvas}) do
    %{
      id: canvas.id,
      name: canvas.name,
      content: canvas.content
    }
  end
end

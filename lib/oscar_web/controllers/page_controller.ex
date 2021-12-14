defmodule OscarWeb.PageController do
  use OscarWeb, :controller

  alias Oscar.Canvas

  def show(conn, %{"id" => id}) do
    canvas = Canvas.get!(id)
    render(conn, "show.html", canvas: canvas)
  end

  def index(conn, _params) do
    canvases = Canvas.list()
    render(conn, "index.html", canvases: canvases)
  end
end

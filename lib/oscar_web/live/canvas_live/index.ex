defmodule OscarWeb.CanvasLive.Index do
  use OscarWeb, :live_view

  alias Oscar.Canvas

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Canvas.subscribe()
    {:ok, assign(socket, :canvases, list_canvases())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Canvas")
    |> assign(:canvas, Canvas.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Canvas")
    |> assign(:canvas, %Canvas{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Canvases")
    |> assign(:canvas, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    canvas = Canvas.get!(id)
    {:ok, _} = Canvas.delete(canvas)

    {:noreply, assign(socket, :canvases, list_canvases())}
  end

  @impl true
  def handle_info( { :canvas_created, canvas }, socket) do
    #{:noreply, update(socket, :canvases, fn canvases -> [canvas | canvases] end)}
    {:noreply, assign(socket, :canvases, list_canvases())}
  end

  defp list_canvases do
    Canvas.list()
  end
end

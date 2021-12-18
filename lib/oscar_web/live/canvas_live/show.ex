defmodule OscarWeb.CanvasLive.Show do
  use OscarWeb, :live_view

  alias Oscar.Canvas

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Canvas.subscribe()
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:canvas, Canvas.get!(id))}
  end

  @impl true
  def handle_info( { :canvas_updated, canvas }, socket) do
    {:noreply, assign(socket, :canvas, Canvas.get!(canvas.id))}
  end

  @impl true
  def handle_info( { :canvas_created, canvas }, socket) do
    {:noreply, assign(socket, :canvas, Canvas.get!(canvas.id))}
  end

  @impl true
  def handle_info( { :canvas_deleted, canvas }, socket) do
    {:noreply, assign(socket, :canvas, nil)}
  end

  defp page_title(:show), do: "Show Canvas"
end

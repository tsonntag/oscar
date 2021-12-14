defmodule OscarWeb.CanvasLive.FormComponent do
  use OscarWeb, :live_component

  alias Oscar.Canvas

  @impl true
  def update(%{canvas: canvas} = assigns, socket) do
    changeset = Canvas.change(canvas)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"canvas" => canvas_params}, socket) do
    changeset =
      socket.assigns.canvas
      |> Canvas.change(canvas_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"canvas" => canvas_params}, socket) do
    save(socket, socket.assigns.action, canvas_params)
  end

  defp save(socket, :edit, canvas_params) do
    case Canvas.update(socket.assigns.canvas, canvas_params) do
      {:ok, } ->
        {:noreply,
         socket
         |> put_flash(:info, "Canvas updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save(socket, :new, canvas_params) do
    case Canvas.create(canvas_params) do
      {:ok, } ->
        {:noreply,
         socket
         |> put_flash(:info, "Canvas created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

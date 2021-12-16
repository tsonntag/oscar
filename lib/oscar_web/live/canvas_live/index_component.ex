defmodule OscarWeb.CanvasLive.IndexComponent do
  use OscarWeb, :live_component


  def render(assigns) do
    ~H"""
    <tr id={"canvas-#{@canvas.id}"}>
      <td><%= @canvas.id %></td>
      <td>
        <span><%= live_redirect "Show", to: Routes.canvas_show_path(@socket, :show, @canvas) %></span>
       </td>
    </tr>
    """
  end

end

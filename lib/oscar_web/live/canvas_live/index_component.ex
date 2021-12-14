defmodule OscarWeb.CanvasLive.IndexComponent do
  use OscarWeb, :live_component


  def render(assigns) do
    ~H"""
    <tr id={"canvas-#{@canvas.id}"}>
      <td><%= @canvas.name %></td>
      <td>
        <span><%= live_redirect "Show", to: Routes.canvas_show_path(@socket, :show, @canvas) %></span>
        <span><%= live_patch "Edit", to: Routes.canvas_index_path(@socket, :edit, @canvas) %></span>
         <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @canvas.id, data: [confirm: "Are you sure?"] %></span>
       </td>
    </tr>
    """
  end

end

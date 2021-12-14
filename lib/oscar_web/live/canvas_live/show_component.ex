defmodule OscarWeb.CanvasLive.ShowComponent do
  use OscarWeb, :live_component


  def render(assigns) do
    ~H"""
    <div id={"canvas-#{@canvas.id}"}>
      <h1><%= @canvas.name %></h1>
      <p>
      <pre><%= @canvas.content%></pre>
      </p>
      <p>
        <span><%= live_patch "Edit", to: Routes.canvas_index_path(@socket, :edit, @canvas) %></span>
        <span><%= live_redirect "Back", to: Routes.canvas_index_path(@socket, :index) %></span>
        <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @canvas.id, data: [confirm: "Are you sure?"] %></span>
       </p>
    </div>
    """
  end

end

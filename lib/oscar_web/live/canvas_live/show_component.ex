defmodule OscarWeb.CanvasLive.ShowComponent do
  use OscarWeb, :live_component


  def render(assigns) do
    ~H"""
    <div id={"canvas-#{@canvas.id}"}>
      <h1><%= @canvas.id %></h1>
      <p>
      <pre><%= @canvas.content%></pre>
      </p>
      <p>
        <span><%= live_redirect "Back", to: Routes.canvas_index_path(@socket, :index) %></span>
       </p>
    </div>
    """
  end

end

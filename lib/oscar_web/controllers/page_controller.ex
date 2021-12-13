defmodule OscarWeb.PageController do
  use OscarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule OscarWeb.CanvasLiveTest do
  use OscarWeb.ConnCase

  import Phoenix.LiveViewTest
  import Oscar.CanvasFixtures

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  defp create_canvas(_) do
    canvas = canvas_fixture()
    %{canvas: canvas}
  end

  describe "Index" do
    setup [:create_canvas]

    test "lists all canvases", %{conn: conn, canvas: canvas} do
      {:ok, _index_live, html} = live(conn, Routes.canvas_index_path(conn, :index))

      assert html =~ "Listing Canvases"
      assert html =~ canvas.content
    end

  end

  describe "Show" do
    setup [:create_canvas]

    test "displays canvas", %{conn: conn, canvas: canvas} do
      {:ok, _show_live, html} = live(conn, Routes.canvas_show_path(conn, :show, canvas))

      assert html =~ "Show Canvas"
      assert html =~ canvas.content
    end
  end
end

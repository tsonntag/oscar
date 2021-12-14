defmodule OscarWeb.CanvasLiveTest do
  use OscarWeb.ConnCase

  import Phoenix.LiveViewTest
  import Oscar.ContentFixtures

  @create_attrs %{content: "some content", name: "some name"}
  @update_attrs %{content: "some updated content", name: "some updated name"}
  @invalid_attrs %{content: nil, name: nil}

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

    test "saves new canvas", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.canvas_index_path(conn, :index))

      assert index_live |> element("a", "New Canvas") |> render_click() =~
               "New Canvas"

      assert_patch(index_live, Routes.canvas_index_path(conn, :new))

      assert index_live
             |> form("#canvas-form", canvas: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#canvas-form", canvas: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.canvas_index_path(conn, :index))

      assert html =~ "Canvas created successfully"
      assert html =~ "some content"
    end

    test "updates canvas in listing", %{conn: conn, canvas: canvas} do
      {:ok, index_live, _html} = live(conn, Routes.canvas_index_path(conn, :index))

      assert index_live |> element("#canvas-#{canvas.id} a", "Edit") |> render_click() =~
               "Edit Canvas"

      assert_patch(index_live, Routes.canvas_index_path(conn, :edit, canvas))

      assert index_live
             |> form("#canvas-form", canvas: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#canvas-form", canvas: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.canvas_index_path(conn, :index))

      assert html =~ "Canvas updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes canvas in listing", %{conn: conn, canvas: canvas} do
      {:ok, index_live, _html} = live(conn, Routes.canvas_index_path(conn, :index))

      assert index_live |> element("#canvas-#{canvas.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#canvas-#{canvas.id}")
    end
  end

  describe "Show" do
    setup [:create_canvas]

    test "displays canvas", %{conn: conn, canvas: canvas} do
      {:ok, _show_live, html} = live(conn, Routes.canvas_show_path(conn, :show, canvas))

      assert html =~ "Show Canvas"
      assert html =~ canvas.content
    end

    test "updates canvas within modal", %{conn: conn, canvas: canvas} do
      {:ok, show_live, _html} = live(conn, Routes.canvas_show_path(conn, :show, canvas))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Canvas"

      assert_patch(show_live, Routes.canvas_show_path(conn, :edit, canvas))

      assert show_live
             |> form("#canvas-form", canvas: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#canvas-form", canvas: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.canvas_show_path(conn, :show, canvas))

      assert html =~ "Canvas updated successfully"
      assert html =~ "some updated content"
    end
  end
end

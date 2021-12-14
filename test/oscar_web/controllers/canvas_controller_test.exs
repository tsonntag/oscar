defmodule OscarWeb.CanvasControllerTest do
  use OscarWeb.ConnCase

  import Oscar.ContextFixtures

  alias Oscar.Context.Canvas

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all canvases", %{conn: conn} do
      conn = get(conn, Routes.canvas_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create canvas" do
    test "renders canvas when data is valid", %{conn: conn} do
      conn = post(conn, Routes.canvas_path(conn, :create), canvas: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.canvas_path(conn, :create), canvas: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update canvas" do
    setup [:create_canvas]

    test "renders canvas when data is valid", %{conn: conn, canvas: %Canvas{id: id} = canvas} do
      conn = put(conn, Routes.canvas_path(conn, :update, canvas), canvas: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, canvas: canvas} do
      conn = put(conn, Routes.canvas_path(conn, :update, canvas), canvas: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete canvas" do
    setup [:create_canvas]

    test "deletes chosen canvas", %{conn: conn, canvas: canvas} do
      conn = delete(conn, Routes.canvas_path(conn, :delete, canvas))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.canvas_path(conn, :show, canvas))
      end
    end
  end

  defp create_canvas(_) do
    canvas = canvas_fixture()
    %{canvas: canvas}
  end
end

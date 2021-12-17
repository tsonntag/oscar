defmodule OscarWeb.CanvasControllerTest do
  use OscarWeb.ConnCase

  import Oscar.CanvasFixtures

  @create_attrs %{
    width: 1, height: 2
  }
  @invalid_attrs %{
    width: 1
  }

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
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.canvas_path(conn, :create), canvas: @invalid_attrs)
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

defmodule Oscar.ContentTest do
  use Oscar.DataCase

  alias Oscar.Content

  describe "canvases" do
    alias Oscar.Content.Canvas

    import Oscar.ContentFixtures

    @invalid_attrs %{content: nil, name: nil}

    test "list_canvases/0 returns all canvases" do
      canvas = canvas_fixture()
      assert Content.list_canvases() == [canvas]
    end

    test "get_canvas!/1 returns the canvas with given id" do
      canvas = canvas_fixture()
      assert Content.get_canvas!(canvas.id) == canvas
    end

    test "create_canvas/1 with valid data creates a canvas" do
      valid_attrs = %{content: "some content", name: "some name"}

      assert {:ok, %Canvas{} = canvas} = Content.create_canvas(valid_attrs)
      assert canvas.content == "some content"
      assert canvas.name == "some name"
    end

    test "create_canvas/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_canvas(@invalid_attrs)
    end

    test "update_canvas/2 with valid data updates the canvas" do
      canvas = canvas_fixture()
      update_attrs = %{content: "some updated content", name: "some updated name"}

      assert {:ok, %Canvas{} = canvas} = Content.update_canvas(canvas, update_attrs)
      assert canvas.content == "some updated content"
      assert canvas.name == "some updated name"
    end

    test "update_canvas/2 with invalid data returns error changeset" do
      canvas = canvas_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_canvas(canvas, @invalid_attrs)
      assert canvas == Content.get_canvas!(canvas.id)
    end

    test "delete_canvas/1 deletes the canvas" do
      canvas = canvas_fixture()
      assert {:ok, %Canvas{}} = Content.delete_canvas(canvas)
      assert_raise Ecto.NoResultsError, fn -> Content.get_canvas!(canvas.id) end
    end

    test "change_canvas/1 returns a canvas changeset" do
      canvas = canvas_fixture()
      assert %Ecto.Changeset{} = Content.change_canvas(canvas)
    end
  end
end

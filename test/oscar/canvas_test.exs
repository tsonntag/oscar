defmodule Oscar.CanvasTest do
  use Oscar.DataCase

  describe "canvases" do
    alias Oscar.Canvas

    import Oscar.CanvasFixtures

    @invalid_attrs %{content: nil}

    test "listes/0 returns all canvases" do
      canvas = canvas_fixture()
      assert Canvas.list() == [canvas]
    end

    test "get!/1 returns the canvas with given id" do
      canvas = canvas_fixture()
      assert Canvas.get!(canvas.id) == canvas
    end

    test "create/1 with valid data creates a canvas" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Canvas{} = canvas} = Canvas.create(valid_attrs)
      assert canvas.content == "some content"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the canvas" do
      canvas = canvas_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Canvas{} = canvas} = Canvas.update(canvas, update_attrs)
      assert canvas.content == "some updated content"
    end

    test "update/2 with invalid data returns error changeset" do
      canvas = canvas_fixture()
      assert {:error, %Ecto.Changeset{}} = Canvas.update(canvas, @invalid_attrs)
      assert canvas == Canvas.get!(canvas.id)
    end

    test "delete/1 deletes the canvas" do
      canvas = canvas_fixture()
      assert {:ok, %Canvas{}} = Canvas.delete(canvas)
      assert_raise Ecto.NoResultsError, fn -> Canvas.get!(canvas.id) end
    end

    test "change/1 returns a canvas changeset" do
      canvas = canvas_fixture()
      assert %Ecto.Changeset{} = Canvas.change(canvas)
    end

    test "new/2 with valid data creates a canvas" do
      valid_attrs = %{"width" => 3, "height" => 4 }
      assert {:ok, %Canvas{} = canvas} == Canvas.create(valid_attrs)
    end

#   test "rect/2 creates rect" do
#     canvas = Canvas.canvas_fixture("width" => )
#     {:ok, %Canvas{content: content}} = Canvas.add_rect(%Canvas{content: "....\n....\n...."},
#       %{"x" => 1, "y" => 1, "width" =>  1, "height" => 2, "fill" => "X"})
#     assert content == ".X..\n.X..\n...."
#   end

  end
end

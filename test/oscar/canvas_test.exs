defmodule Oscar.CanvasTest do
  use Oscar.DataCase

  describe "canvases" do
    alias Oscar.Canvas

    import Oscar.CanvasFixtures

    test "listes/0 returns all canvases" do
      canvas = canvas_fixture()
      assert Canvas.list() == [canvas]
    end

    test "get!/1 returns the canvas with given id" do
      canvas = canvas_fixture()
      assert Canvas.get!(canvas.id) == canvas
    end

    test "create/1 with valid data creates a canvas" do
      valid_attrs = %{"width" => 2, "height" => 3 }
      assert {:ok, %Canvas{} = canvas} = Canvas.create(valid_attrs)
      assert canvas.content == "  \n  \n  "

      valid_attrs = %{"width" => 2, "height" => 3, "fill" => "X" }
      assert {:ok, %Canvas{} = canvas} = Canvas.create(valid_attrs)
      assert canvas.content == "XX\nXX\nXX"
    end

    test "create/1 with invalid data returns error changeset" do
      invalid_attrs = %{"width" => 2, "hght" => 3 }
      assert {:error, %Ecto.Changeset{}} = Canvas.create(invalid_attrs)

      invalid_attrs = %{"height" => 3 }
      assert {:error, %Ecto.Changeset{}} = Canvas.create(invalid_attrs)

      invalid_attrs = %{"width" => 2, "height" => 3, "fill" => "XX" }
      assert {:error, %Ecto.Changeset{}} = Canvas.create(invalid_attrs)
    end

    test "add_rect/1 with invalid data returns error changeset" do
      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"y" => 1, "width" => 3, "height" => 4, "fill" => "X" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_rect(canvas, invalid_attrs)

      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"x" => 1, "xy" => 1, "width" => 3, "height" => 4, "fill" => "X" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_rect(canvas, invalid_attrs)

      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"x" => 1, "y" => 1, "w" => 3, "height" => 4, "fill" => "X" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_rect(canvas, invalid_attrs)

      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"x" => 1, "y" => 1, "width" => 3, "h" => 4, "fill" => "X" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_rect(canvas, invalid_attrs)

      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"x" => 1, "y" => 1, "width" => 3, "height" => 4, "fill" => "XX" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_rect(canvas, invalid_attrs)
     end

    test "add_rect/1 with valid data updates a canvas" do
      canvas = canvas_fixture(%{content: "...\n...\n..."})
      valid_attrs = %{"x" => 0, "y" => 0, "width" => 2, "height" => 2, "fill" => "X" }
      assert {:ok, %Canvas{} = canvas} = Canvas.add_rect(canvas, valid_attrs)
      assert canvas.content == "XX.\nXX.\n..."
     end

    test "add_flood/1 with invalid data returns error changeset" do
      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"y" => 1, "fill" => "X" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_flood(canvas, invalid_attrs)

      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"x" => 1, "xy" => 1, "fill" => "X" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_flood(canvas, invalid_attrs)

      canvas = canvas_fixture(%{content: "...\n..."})
      invalid_attrs = %{"x" => 1, "y" => 1, "fill" => "XX" }
      assert {:error, %Ecto.Changeset{}} = Canvas.add_flood(canvas, invalid_attrs)
     end

    test "add_flood/1 with valid data updates a canvas" do
      canvas = canvas_fixture(%{content: "...\nXXX\nXXX"})
      valid_attrs = %{"x" => 1, "y" => 0, "fill" => "A" }
      assert {:ok, %Canvas{} = canvas} = Canvas.add_flood(canvas, valid_attrs)
      assert canvas.content == "AAA\nXXX\nXXX"
     end

    test "update/2 with valid data updates the canvas" do
      canvas = canvas_fixture()
      valid_attrs = %{content: "some updated content"}
      assert {:ok, %Canvas{} = canvas} = Canvas.update(canvas, valid_attrs)
      assert canvas.content == "some updated content"
    end

    test "delete/1 deletes the canvas" do
      canvas = canvas_fixture()
      assert {:ok, %Canvas{}} = Canvas.delete(canvas)
      assert_raise Ecto.NoResultsError, fn -> Canvas.get!(canvas.id) end
    end

  end
end

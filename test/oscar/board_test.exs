defmodule Oscar.FieldTest do
  use Oscar.DataCase

  describe "fields" do
    alias Oscar.Field

    test "new/1 returns an empty field" do
      assert Field.new(3,2) == %Field{chars: %{}, size: {3,2}}
    end

    test "add_rect/4 adds rect to field" do
      field = Field.new(0,0)
      assert {:ok, %Field{} = canvas} = Field.create(valid_attrs)
      assert canvas.content == "some content"
      assert canvas.name == "some name"
    end

  end
end

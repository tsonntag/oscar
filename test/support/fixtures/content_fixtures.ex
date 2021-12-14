defmodule Oscar.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Oscar.Content` context.
  """

  @doc """
  Generate a canvas.
  """
  def canvas_fixture(attrs \\ %{}) do
    {:ok, canvas} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> Oscar.Content.create_canvas()

    canvas
  end
end

defmodule Oscar.CanvasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Oscar.Canvas`.
  """

  @doc """
  Generate a canvas.
  """
  def canvas_fixture(attrs \\ %{}) do
    {:ok, canvas} =
      attrs
      |> Enum.into(%{
        content: "some content",
      })
      |> Oscar.Canvas.create_content()
    canvas
  end
  
end

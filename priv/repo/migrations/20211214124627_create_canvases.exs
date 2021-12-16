defmodule Oscar.Repo.Migrations.CreateCanvases do
  use Ecto.Migration

  def change do
    create table(:canvases) do
      add :content, :text
    end
  end
end

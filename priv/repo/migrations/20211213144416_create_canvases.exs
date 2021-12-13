defmodule Oscar.Repo.Migrations.CreateCanvases do
  use Ecto.Migration

  def change do
    create table(:canvases) do
      add :name, :string
      add :content, :text
      timestamps()
    end

    create unique_index(:canvases, [:name])
  end
end

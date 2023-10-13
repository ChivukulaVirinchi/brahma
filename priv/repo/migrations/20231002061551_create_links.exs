defmodule Brahma.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :title, :string
      add :likes, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:links, [:user_id])
  end
end

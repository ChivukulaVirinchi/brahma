defmodule Brahma.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :like_count, :integer, default: 0
      add :link_id, references(:links, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:link_id])
    create index(:comments, [:user_id])
  end
end

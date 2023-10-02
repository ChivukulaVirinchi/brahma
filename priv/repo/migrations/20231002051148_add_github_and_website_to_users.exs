defmodule Brahma.Repo.Migrations.AddGithubAndWebsiteToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :website, :string
      add :github, :string
    end
  end
end

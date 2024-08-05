defmodule Brahma.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :like_count, :integer, default: 0
    belongs_to :link, Brahma.Feed.Link
    belongs_to :user, Brahma.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :link_id, :user_id])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 250)
  end
end

defmodule Brahma.Feed.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :title, :string
    field :url, :string
    field :likes, :integer, default: 0
    belongs_to :user, Brahma.Accounts.User
    has_many :comments, Brahma.Comments.Comment
    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :title])
    |> validate_required([:url, :title])
  end
end

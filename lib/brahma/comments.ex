defmodule Brahma.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Brahma.Repo

  alias Brahma.Comments.Comment
  alias Brahma.Accounts
  alias Brahma.Feed.Link

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments() do
    Repo.all(Comments) |> Repo.preload(:link)
  end

  def list_comments_by_link_id(id) do
    query =
      from c in Comment,
        where: c.link_id == ^id,
        order_by: [desc: :inserted_at],
        select: c
    Repo.all(query)
    |> Repo.preload(:link)
    |> Repo.preload(:user)
  end

  def count_comments_by_link_id(id) do
    query =
      from c in Comment,
        where: c.link_id == ^id
   count = Repo.aggregate(query, :count, :id)
    broadcast({:ok, count}, :comment_count_updated)
    count
  end


  def inc_comment_likes(%Comment{id: id}) do
    {1, [comment]} =
      from(p in Comment, where: p.id == ^id, select: p)
      |> Repo.update_all(inc: [like_count: 1])
    comment = comment |> Repo.preload(:user) |> Repo.preload(:link)
    broadcast({:ok, comment}, :comment_updated)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id) |> Repo.preload(:link)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(%Link{} = link, %Accounts.User{} = user, attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:link, link)
    |> Repo.insert()
    |> broadcast(:comment_created)
  end

  # def update_comment(%Comment{} = comment, attrs) do
  #   comment
  #   |> Comment.changeset(attrs)
  #   |> Repo.update()
  # end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """


  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
    |> broadcast(:comment_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Brahma.PubSub, "comments")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Comment{} = comment}, event) do
    Phoenix.PubSub.broadcast(Brahma.PubSub, "comments", {event, comment})
    {:ok, comment}
  end

  defp broadcast({:ok, count}, event) do
    Phoenix.PubSub.broadcast(Brahma.PubSub, "comments", {event, count})
    {:ok, count}
  end
end

defmodule Brahma.Feed do
  @moduledoc """
  The Feed context.
  """

  import Ecto.Query, warn: false
  alias Brahma.Repo

  alias Brahma.Feed.Link
  alias Brahma.Accounts

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link) |> Repo.preload(:user)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id) |> Repo.preload(:user)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(%Accounts.User{} = user, attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
    |> broadcast(:link_created)
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
    |> broadcast(:link_updated)
  end

  def inc_likes(%Link{id: id}) do
    {1, [link]} =
      from(p in Link, where: p.id == ^id, select: p)
      |> Repo.update_all(inc: [likes: 1])
 link = link |> Repo.preload(:user)

    broadcast({:ok, link}, :link_updated)
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
    |> broadcast(:link_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Brahma.PubSub, "links")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Link{} = link}, event) do
    Phoenix.PubSub.broadcast(Brahma.PubSub, "links", {event, link})
    {:ok, link}
  end
end

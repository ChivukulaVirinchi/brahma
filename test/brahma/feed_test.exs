defmodule Brahma.FeedTest do
  use Brahma.DataCase

  alias Brahma.Feed

  describe "links" do
    alias Brahma.Feed.Link

    import Brahma.FeedFixtures

    @invalid_attrs %{title: nil, url: nil, likes: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Feed.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Feed.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{title: "some title", url: "some url", likes: 42}

      assert {:ok, %Link{} = link} = Feed.create_link(valid_attrs)
      assert link.title == "some title"
      assert link.url == "some url"
      assert link.likes == 42
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feed.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url", likes: 43}

      assert {:ok, %Link{} = link} = Feed.update_link(link, update_attrs)
      assert link.title == "some updated title"
      assert link.url == "some updated url"
      assert link.likes == 43
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Feed.update_link(link, @invalid_attrs)
      assert link == Feed.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Feed.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Feed.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Feed.change_link(link)
    end
  end
end

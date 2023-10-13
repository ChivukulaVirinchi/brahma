defmodule Brahma.FeedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Brahma.Feed` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url",
        likes: 42
      })
      |> Brahma.Feed.create_link()

    link
  end
end

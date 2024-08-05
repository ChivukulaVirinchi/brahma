defmodule Brahma.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Brahma.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        likes: 42
      })
      |> Brahma.Comments.create_comment()

    comment
  end
end

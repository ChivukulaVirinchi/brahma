defmodule BrahmaWeb.CommentLive.Index do
  use BrahmaWeb, :live_view

  alias Brahma.Comments
  alias Brahma.Feed
  alias Brahma.Comments.Comment

  @impl true
  def mount(%{"id" => link_id}, _session, socket) do
    if connected?(socket), do: Comments.subscribe()
    if connected?(socket), do: Feed.subscribe()

    socket = socket
    |> assign(:link, Brahma.Feed.get_link!(link_id))
    |> assign(:comment_count, Comments.count_comments_by_link_id(link_id))
    |> assign(:form, to_form(Comments.change_comment(%Comment{})))
    |> stream(:comments, Comments.list_comments_by_link_id(link_id))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"comment" => params}, socket) do
    form =
      %Comment {}
      |> Comments.change_comment(params)
      |> Map.put(:action, :validate)
      |> to_form()
    socket = assign(socket, :form, form)
    {:noreply, socket}
  end

  def handle_event("save", %{"comment" => params}, socket) do
    if socket.assigns.current_user do
      case Comments.create_comment(socket.assigns.link, socket.assigns.current_user, params) do
        {:ok, comment} ->
          socket = socket
          |> stream_insert(:comments, comment, at: 0)
          |> put_flash(:info, "Comment created!")
          |> assign(:form, to_form(Comments.change_comment(%Comment{})))

          {:noreply, socket}
        {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
    end
end

def handle_event("delete", %{"id" => id}, socket) do
 if socket.assigns.current_user == Comments.get_comment!(id).user do
  comment = Comments.get_comment!(id)
  {:ok, _} = Comments.delete_comment(comment)
  {:noreply, socket}
 end
end

@impl true

def handle_info({:comment_created, comment}, socket) do
  {:noreply, stream_insert(socket, :comments, comment, at: 0)}
end

def handle_info({:comment_count_updated, comment_count}, socket) do
  {:noreply, assign(socket, :comment_count, comment_count)}
end

def handle_info({:comment_updated, comment}, socket) do
  {:noreply, stream_insert(socket, :comments, comment)}
end

def handle_info({:comment_deleted, comment}, socket) do
  {:noreply, stream_delete(socket, :comments, comment)}
end

end

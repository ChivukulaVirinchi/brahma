defmodule BrahmaWeb.LinkLive.Index do
  use BrahmaWeb, :live_view

  alias Brahma.Feed
  alias Brahma.Feed.Link
  use Timex


    @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Feed.subscribe()

    {:ok, stream(socket, :links, Feed.list_links())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Link")
    |> assign(:link, Feed.get_link!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Link")
    |> assign(:link, %Link{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Links")
    |> assign(:link, nil)
  end

  @impl true
  def handle_info({BrahmaWeb.LinkLive.FormComponent, {:saved, link}}, socket) do
    {:noreply, stream_insert(socket, :links, link)}
  end

  def handle_info({:link_created, link}, socket) do
    {:noreply, stream_insert(socket, :links, link, at: 0)}
  end

  def handle_info({:link_updated, link}, socket) do
    {:noreply, stream_insert(socket, :links, link)}
  end

  def handle_info({:link_deleted, link}, socket) do
    {:noreply, stream_delete(socket, :links, link)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    link = Feed.get_link!(id)
    {:ok, _} = Feed.delete_link(link)

    socket =
      socket
      |> put_flash(:info, "Link deleted successfully")

    {:noreply, socket}
  end
end

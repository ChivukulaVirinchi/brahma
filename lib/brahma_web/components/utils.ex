defmodule BrahmaWeb.Utils do

  alias Brahma.Feed.Link
  def get_name(email) do
    [name | _] = String.split(email, "@")
    String.capitalize(name)
  end

  def handle_event("like", %{"link" => id}, socket) do
    link = %Link{id: id}
    Brahma.Feed.inc_likes(link)
    {:noreply, socket}
  end


end

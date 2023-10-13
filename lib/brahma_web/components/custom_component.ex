defmodule BrahmaWeb.CustomComponent do
  use BrahmaWeb, :live_component

  alias Brahma.Feed
  alias Brahma.Feed.Link
  use Timex


  def render(assigns) do
    ~H"""
    <div class="w-full dark:bg-black" id={ider(@link.id)}>
      <div class="p-4 bg-gray-100 border rounded-sm">
        <a href={@link.url} class="text-lg font-medium hover:text-blue-500"><%= @link.title %></a>
        <span class="px-1 text-xs bg-blue-100 border border-blue-500 rounded-md">programming</span>
        <span class="px-1 text-xs bg-yellow-100 border border-yellow-500 rounded-md">phoenix</span>

        <div class="flex mt-2 space-x-4">
          <a href="http://">
            <div class="flex items-center space-x-1">
              <img
                class="rounded-full h-7 w-7"
                src="https://www.virinchi.me/img/virinchi_hu922a05f833375c24fc0b469acb202f7a_6128766_288x288_fill_q75_h2_box_center_2.webp"
              />
              <a href="" class="text-sm font-medium"><%= get_name(@user.email) %></a>
            </div>
          </a>
            <div class="flex items-center space-x-1 group pointer-cursor">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-4 h-4 text-gray-400 group-hover:fill-current group-hover:text-pink-600"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"
                />
              </svg>
              <button type="button" phx-target={@myself} phx-click="like" phx-value-link={@link.id} class="text-xs group">
                <%= @link.likes %> likes
              </button>
            </div>

            <div class="flex items-center space-x-1">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-4 h-4 text-gray-400"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M20.25 8.511c.884.284 1.5 1.128 1.5 2.097v4.286c0 1.136-.847 2.1-1.98 2.193-.34.027-.68.052-1.02.072v3.091l-3-3c-1.354 0-2.694-.055-4.02-.163a2.115 2.115 0 01-.825-.242m9.345-8.334a2.126 2.126 0 00-.476-.095 48.64 48.64 0 00-8.048 0c-1.131.094-1.976 1.057-1.976 2.192v4.286c0 .837.46 1.58 1.155 1.951m9.345-8.334V6.637c0-1.621-1.152-3.026-2.76-3.235A48.455 48.455 0 0011.25 3c-2.115 0-4.198.137-6.24.402-1.608.209-2.76 1.614-2.76 3.235v6.226c0 1.621 1.152 3.026 2.76 3.235.577.075 1.157.14 1.74.194V21l4.155-4.155"
                />
              </svg>
              <a href="" class="text-xs" for="">2 comments</a>
            </div>

          <a href="http://">
            <div class="flex items-center">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-5 h-5 text-gray-500"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z"
                />
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M19.5 10.5c0 7.142-7.5  11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z"
                />
              </svg>
              <a href={get_domain(@link.url)} class="text-xs" for=""><%=  %></a>
            </div>
          </a>

          <span>
            <div class="flex items-center space-x-1">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-4 h-4 text-gray-500"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <a class="text-xs" href=""><%= Timex.from_now(@link.inserted_at) %></a>
            </div>
          </span>

          <.link
            phx-click={JS.push("delete", value: %{id: @link.id}) |> hide("##{@link.id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
          <.link patch={~p"/links/#{@link}/edit"}>Edit</.link>
        </div>
      </div>
    </div>
    """
  end

  @impl true

  def handle_event("like", %{"link" => id}, socket) do
    link = %Link{id: id}
    Brahma.Feed.inc_likes(link)
    {:noreply, socket}
  end


  def get_name(email) do
    [name | _] = String.split(email, "@")
    String.capitalize(name)
  end

  def get_domain(url) do
    url = String.replace(url, ~r/^https?:\/\//, "")
    [domain | _] = String.split(url, "/")
    domain
  end

  def ider(id) do
    value = id |> Integer.to_string()
    "links-" <> value
  end

end

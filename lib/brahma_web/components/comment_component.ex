  defmodule BrahmaWeb.CommentComponent do
    use BrahmaWeb, :live_component
  use Timex
  import BrahmaWeb.Utils
  alias Brahma.Comments
  alias Brahma.Comments.Comment

  def render(assigns) do
    ~H"""
    <div class="p-3 bg-teal-100 rounded-md" id={ider(@comment.id)}>
      <div class="items-center md:flex md:space-x-3">
        <img
          class="hidden w-8 h-8 border border-teal-600 rounded-full select-none md:block"
          src="https://www.virinchi.me/img/virinchi_hu922a05f833375c24fc0b469acb202f7a_6128766_288x288_fill_q75_h2_box_center_2.webp"
        />
        <div>
          <a class="font-semibold text-gray-700 hover:underline" href="#"> <%= get_name(@comment.user.email) %> </a>
          &bull;
          <span class="text-xs text-gray-500"><%= Timex.from_now(@comment.inserted_at) %></span>
          <p class="mt-1 text-sm text-left text-gray-600"><%= @comment.body %></p>
        </div>
      </div>

      <div class="flex mt-2 space-x-4 md:pl-6">
        <div class="flex items-center space-x-1 cursor-pointer group">
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
          <button phx-click="comment-liked" phx-value-comment={@comment.id} phx-target={@myself} type="button" class="text-sm select-none group group-hover:text-pink-600">
            <%= @comment.like_count %> likes
          </button>
        </div>
          <.link
          phx-click={JS.push("delete", value: %{id: @comment.id}) |> hide("##{@comment.id}")}
            data-confirm="You sure you want to trash this?"
          >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 fill-none">
            <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
          </svg>

          </.link>

      </div>
    </div>
    """
  end

  def handle_event("comment-liked", %{"comment" => id}, socket) do
    comment = %Comment{id: id}
    Comments.inc_comment_likes(comment)
    {:noreply, socket}
  end

  def ider(id) do
    value = id |> Integer.to_string()
    "comments-" <> value
  end

end

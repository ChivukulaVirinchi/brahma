defmodule Brahma.Repo do
  use Ecto.Repo,
    otp_app: :brahma,
    adapter: Ecto.Adapters.Postgres
end

defmodule AllShursBot.Repo do
  use Ecto.Repo,
    otp_app: :all_shurs_bot,
    adapter: Ecto.Adapters.Postgres
end

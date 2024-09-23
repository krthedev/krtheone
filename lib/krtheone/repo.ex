defmodule Krtheone.Repo do
  use Ecto.Repo,
    otp_app: :krtheone,
    adapter: Ecto.Adapters.Postgres
end

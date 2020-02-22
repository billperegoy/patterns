defmodule Patterns.Repo do
  use Ecto.Repo,
    otp_app: :patterns,
    adapter: Ecto.Adapters.Postgres
end

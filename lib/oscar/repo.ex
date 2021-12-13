defmodule Oscar.Repo do
  use Ecto.Repo,
    otp_app: :oscar,
    adapter: Ecto.Adapters.Postgres
end

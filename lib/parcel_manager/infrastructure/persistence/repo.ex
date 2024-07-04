defmodule ParcelManager.Infrastructure.Persistence.Repo do
  use Ecto.Repo,
    otp_app: :parcel_manager,
    adapter: Ecto.Adapters.Postgres
end

defmodule ParcelManager.Infrastructure.Persistence.Repo.Migrations.AddIndexesToTransfers do
  use Ecto.Migration

  def change do
    create index(:transfers, [:parcel_id])
    create index(:transfers, [:location_id])
  end
end

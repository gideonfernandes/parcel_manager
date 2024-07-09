defmodule ParcelManager.Infrastructure.Persistence.Repo.Migrations.AddIndexesToParcels do
  use Ecto.Migration

  def change do
    create index(:parcels, [:source_id])
    create index(:parcels, [:current_id])
    create index(:parcels, [:destination_id])
  end
end

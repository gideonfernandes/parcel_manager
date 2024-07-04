defmodule ParcelManager.Infrastructure.Persistence.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add(:id, :uuid, primary_key: true, null: false)
      add(:location_id, references(:locations, type: :uuid), null: false)
      add(:parcel_id, references(:parcels, type: :uuid), null: false)

      timestamps(updated_at: false)
    end
  end
end

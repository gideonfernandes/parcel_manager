defmodule ParcelManager.Infrastructure.Persistence.Repo.Migrations.AddCurrentIdToParcels do
  use Ecto.Migration

  def change do
    alter table(:parcels) do
      add(:current_id, references(:locations, type: :uuid), null: false)
    end
  end
end

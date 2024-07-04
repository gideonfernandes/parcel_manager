defmodule ParcelManager.Infrastructure.Persistence.Repo.Migrations.CreateParcels do
  use Ecto.Migration

  def change do
    create table(:parcels, primary_key: false) do
      add(:id, :uuid, primary_key: true, null: false)
      add(:description, :string, null: false)
      add(:state, :string, default: "pending")
      add(:reason, :string, null: true)
      add(:is_delivered, :boolean, default: false)
      add(:source_id, references(:locations, type: :uuid), null: false)
      add(:destination_id, references(:locations, type: :uuid), null: false)

      timestamps()
    end
  end
end

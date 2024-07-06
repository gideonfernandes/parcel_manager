defmodule ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepository do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Repositories.Macro

  @spec get(parcel_id :: Ecto.UUID.t()) :: Schemas.Parcel.t() | nil
  def get(parcel_id) do
    Schemas.Parcel
    |> from(as: :parcel, preload: [:source, :destination, transfers: :location])
    |> Queries.Parcel.by_id(parcel_id)
    |> Queries.Parcel.with_source()
    |> Queries.Parcel.with_destination()
    |> select(
      [parcel: p],
      map(p, [
        :id,
        :description,
        :is_delivered,
        :source_id,
        :destination_id,
        :reason,
        :state,
        source: [:id, :name],
        transfers: [:inserted_at, :location_id, location: [:id, :name]],
        destination: [:id, :name]
      ])
    )
    |> Repo.one(telemetry_options: [name: :get_parcel])
  end

  @spec create(attrs :: map) :: {:ok, Schemas.Parcel.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Schemas.Parcel{}
    |> Schemas.Parcel.changeset(attrs)
    |> Repo.insert(telemetry_options: [name: :create_parcel])
  end
end

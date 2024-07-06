defmodule ParcelManager.Infrastructure.Persistence.Repositories.LocationRepository do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Repositories.Macro

  @parcel_fields [
    :id,
    :description,
    :is_delivered,
    :source_id,
    :destination_id,
    source: [:id, :name],
    destination: [:id, :name]
  ]

  @spec get(location_id :: Ecto.UUID.t()) :: map() | nil
  def get(location_id) do
    Schemas.Location
    |> from(
      as: :location,
      preload: [
        source_parcels: [:source, :destination],
        destination_parcels: [:source, :destination]
      ]
    )
    |> Queries.Location.by_id(location_id)
    |> select(
      [location: l],
      map(l, [
        :id,
        :name,
        source_parcels: @parcel_fields,
        destination_parcels: @parcel_fields
      ])
    )
    |> Repo.one(telemetry_options: [name: :get_location])
  end
end

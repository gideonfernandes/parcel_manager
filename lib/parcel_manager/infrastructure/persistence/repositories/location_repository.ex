defmodule ParcelManager.Infrastructure.Persistence.Repositories.LocationRepository do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Repositories.Macro

  @location_fields ~w/id name/a
  @parcel_assoc_fields [source: @location_fields, destination: @location_fields]
  @parcel_fields ~w/id description is_delivered source_id destination_id/a ++ @parcel_assoc_fields

  @spec get(location_id :: Ecto.UUID.t()) :: map() | nil
  def get(location_id) do
    Schemas.Location
    |> from(as: :location, preload: [current_parcels: [:source, :destination]])
    |> Queries.Location.by_id(location_id)
    |> select([location: l], map(l, @location_fields))
    |> select_merge([location: l], map(l, current_parcels: @parcel_fields))
    |> Repo.one(telemetry_options: [name: :get_location])
  end
end

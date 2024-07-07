defmodule ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepository do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Repositories.Macro

  @location_fields [:id, :name]
  @transfers_fields [:inserted_at, :location_id, location: [:id, :name]]

  @get_select_fields [
    :id,
    :description,
    :is_delivered,
    :source_id,
    :destination_id,
    :reason,
    :state,
    source: @location_fields,
    transfers: @transfers_fields,
    destination: @location_fields
  ]

  @spec get(parcel_id :: Ecto.UUID.t()) :: map() | nil
  def get(parcel_id) do
    Schemas.Parcel
    |> from(as: :parcel, preload: [:source, :destination, transfers: :location])
    |> Queries.Parcel.by_id(parcel_id)
    |> Queries.Parcel.with_source()
    |> Queries.Parcel.with_destination()
    |> select([parcel: p], map(p, @get_select_fields))
    |> Repo.one(telemetry_options: [name: :get_parcel])
  end

  @spec create(attrs :: map()) :: {:ok, Schemas.Parcel.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Schemas.Parcel{}
    |> Schemas.Parcel.changeset(attrs)
    |> Repo.insert(telemetry_options: [name: :create_parcel])
  end

  @spec update(parcel :: Schemas.Parcel.t(), attrs :: map()) ::
          {:ok, Schemas.Parcel.t()} | {:error, Ecto.Changeset.t()}
  def update(parcel, attrs) do
    parcel
    |> Schemas.Parcel.changeset(attrs)
    |> Repo.update(telemetry_options: [name: :update_parcel])
  end
end

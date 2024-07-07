defmodule ParcelManager.Domain.Entities.Parcel do
  @moduledoc false

  use ParcelManager.Domain.Entities.Macro

  defdelegate create(attrs), to: Repositories.ParcelRepository, as: :create
  defdelegate get(attrs), to: Repositories.ParcelRepository, as: :get
  defdelegate with_transfers(parcel_id), to: Queries.Parcel, as: :with_transfers
  defdelegate update(parcel, attrs), to: Repositories.ParcelRepository, as: :update

  @type check_transferability_errors ::
          :already_delivered
          | :cannot_be_transferred_to_current_location
          | :cannot_be_returned_to_previous_locations

  @spec check_transferability(parcel :: Schemas.Parcel.t(), location :: Schemas.Location.t()) ::
          {:ok, true} | {:error, check_transferability_errors()}
  def check_transferability(%Schemas.Parcel{} = parcel, %Schemas.Location{id: location_id}) do
    cond do
      parcel.state == :delivered and parcel.is_delivered -> {:error, :already_delivered}
      is_current?(parcel, location_id) -> {:error, :cannot_be_transferred_to_current_location}
      is_returning?(parcel, location_id) -> {:error, :cannot_be_returned_to_previous_locations}
      true -> {:ok, true}
    end
  end

  defp is_current?(parcel, transfer_location_id) do
    transfer_location_id == parcel.current_id
  end

  defp is_returning?(parcel, transfer_location_id) do
    transfer_location_id in (Enum.map(parcel.transfers, & &1.location_id) ++ [parcel.source_id])
  end

  @spec destination_arrived?(parcel :: Schemas.Parcel.t(), location :: Schemas.Location.t()) ::
          boolean()
  def destination_arrived?(%Schemas.Parcel{} = parcel, %Schemas.Location{} = location) do
    location.id == parcel.destination_id
  end
end

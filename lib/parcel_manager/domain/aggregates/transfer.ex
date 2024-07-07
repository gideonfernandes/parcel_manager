defmodule ParcelManager.Domain.Aggregates.Transfer do
  @moduledoc false

  use ParcelManager.Domain.Aggregates.Macro

  @type transfer_parcel_errors ::
          :already_delivered
          | :cannot_be_transferred_to_current_location
          | :cannot_be_returned_to_previous_locations

  @spec transfer_parcel(parcel :: Schemas.Parcel.t(), location :: Schemas.Location.t()) ::
          {:ok, map()} | {:error, transfer_parcel_errors()}
  def transfer_parcel(parcel, location) do
    with {:ok, true} <- Entities.Parcel.check_transferability(parcel, location),
         {:ok, transfer} <-
           Entities.Transfer.create(%{parcel_id: parcel.id, location_id: location.id}),
         {:ok, result} <- update_parcel(parcel, location) do
      {:ok, %{transfer: transfer, update_parcel: result}}
    end
  end

  defp update_parcel(parcel, location) do
    if Entities.Parcel.destination_arrived?(parcel, location) do
      Entities.Parcel.update(parcel, %{
        is_delivered: true,
        state: :delivered,
        current_id: location.id
      })
    else
      Entities.Parcel.update(parcel, %{state: :in_transit, current_id: location.id})
    end
  end
end

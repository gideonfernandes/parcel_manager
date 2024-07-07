defmodule ParcelManager.Domain.Aggregates.Transfer do
  @moduledoc false

  use ParcelManager.Domain.Aggregates.Macro

  @spec transfer_parcel(parcel :: Schemas.Parcel.t(), location :: Schemas.Location.t()) ::
          {:error, :already_delivered | :cannot_be_returned_to_previous_locations}
  def transfer_parcel(parcel, location) do
    with {:ok, true} <- Entities.Parcel.check_transferability(parcel, location),
         {:ok, transfer} <-
           Entities.Transfer.create(%{parcel_id: parcel.id, location_id: location.id}),
         {:ok, update_parcel} <- maybe_update_parcel(parcel, location) do
      {:ok, %{transfer: transfer, update_parcel: update_parcel}}
    end
  end

  defp maybe_update_parcel(parcel, location) do
    if Entities.Parcel.destination_arrived?(parcel, location) do
      Entities.Parcel.update(parcel, %{is_delivered: true, state: :delivered})
    else
      {:ok, :skipped}
    end
  end
end

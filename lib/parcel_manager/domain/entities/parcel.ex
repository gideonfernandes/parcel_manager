defmodule ParcelManager.Domain.Entities.Parcel do
  @moduledoc false

  use ParcelManager.Domain.Entities.Macro

  defdelegate create(attrs), to: Repositories.ParcelRepository, as: :create
  defdelegate get(attrs), to: Repositories.ParcelRepository, as: :get
  defdelegate with_transfers(parcel_id), to: Queries.Parcel, as: :with_transfers
  defdelegate update(parcel, attrs), to: Repositories.ParcelRepository, as: :update

  @spec destination_arrived?(parcel :: Schemas.Parcel.t(), location :: Schemas.Location.t()) ::
          boolean()
  def destination_arrived?(%Schemas.Parcel{} = parcel, %Schemas.Location{} = location) do
    location.id == parcel.destination_id
  end
end

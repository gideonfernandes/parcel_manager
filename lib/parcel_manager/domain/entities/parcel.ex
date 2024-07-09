defmodule ParcelManager.Domain.Entities.Parcel do
  @moduledoc false

  use ParcelManager.Domain.Entities.Macro

  @type cancelability_errors :: :already_canceled | :already_in_transit | :already_delivered
  @type check_cancelability_output :: {:ok, true} | {:error, cancelability_errors()}

  defdelegate create(attrs), to: Repositories.ParcelRepository, as: :create
  defdelegate get(attrs), to: Repositories.ParcelRepository, as: :get
  defdelegate update(parcel, attrs), to: Repositories.ParcelRepository, as: :update
  defdelegate cancel(parcel, attrs), to: Repositories.ParcelRepository, as: :cancel
  defdelegate by_id(location_id), to: Queries.Parcel, as: :by_id
  defdelegate with_transfers(parcel_id), to: Queries.Parcel, as: :with_transfers

  @spec destination_arrived?(parcel :: Schemas.Parcel.t(), location :: Schemas.Location.t()) ::
          boolean()
  def destination_arrived?(%Schemas.Parcel{} = parcel, %Schemas.Location{} = location) do
    location.id == parcel.destination_id
  end

  @spec check_cancelability(parcel :: Schemas.Parcel.t()) :: check_cancelability_output()
  def check_cancelability(%Schemas.Parcel{} = parcel) do
    cond do
      parcel.state == :canceled -> {:error, :already_canceled}
      parcel.state == :in_transit -> {:error, :already_in_transit}
      delivered?(parcel) -> {:error, :already_delivered}
      parcel.state == :pending -> {:ok, true}
    end
  end

  @spec delivered?(parcel :: Schemas.Parcel.t()) :: boolean()
  def delivered?(%Schemas.Parcel{} = parcel) do
    parcel.state == :delivered and parcel.is_delivered
  end
end

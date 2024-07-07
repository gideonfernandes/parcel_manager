defmodule ParcelManager do
  @moduledoc """
  ParcelManager keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ParcelManager.Application.Dtos
  alias ParcelManager.Application.Error
  alias ParcelManager.Application.UseCases

  @spec create_parcel(map()) :: {:ok, map()} | {:error, Error.t()}
  def create_parcel(params) do
    with {:ok, dto} <- Dtos.CreateParcel.build(params),
         {:ok, parcel} <- UseCases.CreateParcel.call(dto) do
      {:ok, parcel}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec get_parcel(map()) :: {:ok, map()} | {:error, Error.t()}
  def get_parcel(params) do
    with {:ok, dto} <- Dtos.GetParcel.build(params),
         {:ok, parcel} <- UseCases.GetParcel.call(dto) do
      {:ok, parcel}
    else
      {:error, :parcel_not_found} -> {:error, Error.build(:not_found, "parcel not found")}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec transfer_parcel(map()) :: {:ok, map()} | {:error, Error.t()}
  def transfer_parcel(params) do
    with {:ok, dto} <- Dtos.TransferParcel.build(params),
         {:ok, %{transfer_parcel: transfer_parcel}} <- UseCases.TransferParcel.call(dto) do
      {:ok, transfer_parcel.transfer}
    else
      {:error, :parcel_not_found} ->
        {:error, Error.build(:not_found, "parcel not found")}

      {:error, :location_not_found} ->
        {:error, Error.build(:not_found, "location not found")}

      {:error, :already_delivered} ->
        {:error, Error.build(:bad_request, "parcel is already delivered")}

      {:error, :cannot_be_transferred_to_current_location} ->
        {:error, Error.build(:bad_request, "parcel cannot be transferred to current location")}

      {:error, :cannot_be_returned_to_previous_locations} ->
        {:error, Error.build(:bad_request, "parcel cannot be returned to previous locations")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec get_location(map()) :: {:ok, map()} | {:error, Error.t()}
  def get_location(params) do
    with {:ok, dto} <- Dtos.GetLocation.build(params),
         {:ok, location} <- UseCases.GetLocation.call(dto) do
      {:ok, location}
    else
      {:error, :location_not_found} -> {:error, Error.build(:not_found, "location not found")}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end
end

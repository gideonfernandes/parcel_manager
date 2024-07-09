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
  alias ParcelManager.Infrastructure.Persistence.Schemas

  @spec get_location(map()) :: {:ok, map()} | {:error, Error.t()}
  def get_location(params) do
    case Dtos.GetLocation.build(params) do
      {:ok, dto} -> UseCases.GetLocation.call(dto)
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec create_parcel(map()) :: {:ok, Schemas.Parcel.t()} | {:error, Error.t()}
  def create_parcel(params) do
    case Dtos.CreateParcel.build(params) do
      {:ok, dto} -> UseCases.CreateParcel.call(dto)
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec get_parcel(map()) :: {:ok, map()} | {:error, Error.t()}
  def get_parcel(params) do
    case Dtos.GetParcel.build(params) do
      {:ok, dto} -> UseCases.GetParcel.call(dto)
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec transfer_parcel(map()) :: {:ok, map()} | {:error, Error.t()}
  def transfer_parcel(params) do
    case Dtos.TransferParcel.build(params) do
      {:ok, dto} -> UseCases.TransferParcel.call(dto)
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end

  @spec cancel_parcel(map()) :: {:ok, map()} | {:error, Error.t()}
  def cancel_parcel(params) do
    case Dtos.CancelParcel.build(params) do
      {:ok, dto} -> UseCases.CancelParcel.call(dto)
      {:error, %Ecto.Changeset{} = changeset} -> {:error, Error.build(:bad_request, changeset)}
    end
  end
end

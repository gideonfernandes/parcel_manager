defmodule ParcelManager.Factory do
  @moduledoc """
  Support module responsible for providing factories to facilitate
  data persistence in tests.
  """

  use ExMachina.Ecto, repo: ParcelManager.Infrastructure.Persistence.Repo

  alias ParcelManager.Application.Dtos
  alias ParcelManager.Infrastructure.Persistence.Schemas

  @spec location_factory :: map()
  def location_factory do
    %Schemas.Location{id: Faker.UUID.v4(), name: Faker.Address.PtBr.city()}
  end

  @spec parcel_factory :: map()
  def parcel_factory do
    source = build(:location)
    destination = build(:location)

    %Schemas.Parcel{
      id: Faker.UUID.v4(),
      description: Faker.Lorem.sentence(),
      source: source,
      state: :pending,
      is_delivered: false,
      source_id: source.id,
      destination: destination,
      destination_id: destination.id
    }
  end

  @spec transfer_factory :: map()
  def transfer_factory do
    location = build(:location)
    parcel = build(:parcel)

    %Schemas.Transfer{
      id: Faker.UUID.v4(),
      location: location,
      location_id: location.id,
      parcel: parcel,
      parcel_id: parcel.id
    }
  end

  @spec create_parcel_dto_factory :: map()
  def create_parcel_dto_factory do
    %Dtos.CreateParcel{
      description: Faker.Lorem.sentence(),
      source_id: Faker.UUID.v4(),
      destination_id: Faker.UUID.v4()
    }
  end

  @spec get_parcel_dto_factory :: map()
  def get_parcel_dto_factory do
    %Dtos.GetParcel{parcel_id: Faker.UUID.v4()}
  end
end

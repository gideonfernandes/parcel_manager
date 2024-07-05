defmodule ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepositoryTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepository
  alias ParcelManager.Infrastructure.Persistence.Schemas.Parcel

  describe "create/1" do
    test "creates a parcel" do
      source = insert(:location)
      destination = insert(:location)
      attrs = params_for(:parcel, source_id: source.id, destination_id: destination.id)

      assert {:ok, %Parcel{} = parcel} = ParcelRepository.create(attrs)
      assert parcel.description == attrs.description
      assert parcel.source_id == attrs.source_id
      assert parcel.destination_id == attrs.destination_id
    end

    test "returns error when unable to insert" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = ParcelRepository.create(attrs)
    end
  end
end

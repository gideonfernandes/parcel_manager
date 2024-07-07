defmodule ParcelManager.Infrastructure.Persistence.Repositories.TransferRepositoryTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Repositories.TransferRepository
  alias ParcelManager.Infrastructure.Persistence.Schemas.Transfer

  describe "create/1" do
    test "creates a transfer" do
      location = insert(:location)
      parcel = insert(:parcel)
      attrs = params_for(:transfer, location_id: location.id, parcel_id: parcel.id)

      assert {:ok, %Transfer{} = parcel} = TransferRepository.create(attrs)
      assert parcel.location_id == attrs.location_id
      assert parcel.parcel_id == attrs.parcel_id
    end

    test "returns error when unable to insert" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = TransferRepository.create(attrs)
    end
  end
end

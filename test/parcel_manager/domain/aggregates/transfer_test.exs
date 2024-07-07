defmodule ParcelManager.Domain.Aggregates.TransferTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Domain.Aggregates.Transfer
  alias ParcelManager.Infrastructure.Persistence.Schemas

  describe "transfer_parcel/2" do
    test "returns error when parcel is not transferable" do
      location1 = insert(:location)
      location2 = insert(:location)
      location3 = insert(:location)
      parcel = insert(:parcel, destination_id: location3.id, destination: location3)

      insert(:transfer,
        location_id: location1.id,
        location: location1,
        parcel_id: parcel.id,
        parcel: parcel
      )

      insert(:transfer,
        location_id: location2.id,
        location: location2,
        parcel_id: parcel.id,
        parcel: parcel
      )

      parcel_with_transfers =
        Schemas.Parcel
        |> Repo.get!(parcel.id)
        |> Repo.preload(:transfers)

      assert {:error, :cannot_be_returned_to_previous_locations} =
               Transfer.transfer_parcel(parcel_with_transfers, location2)
    end

    test "transfers parcel to location skipping parcel updating to deliver" do
      location1 = insert(:location)
      location2 = insert(:location)
      insert(:parcel, destination_id: location1.id, destination: location1)

      parcel =
        Schemas.Parcel
        |> Repo.one!()
        |> Repo.preload(:transfers)

      assert {:ok, %{transfer: _, update_parcel: :skipped}} =
               Transfer.transfer_parcel(parcel, location2)
    end

    test "transfers parcel to location & updates parcel to delivered" do
      _location1 = insert(:location)
      location2 = insert(:location)
      insert(:parcel, destination_id: location2.id, destination: location2)

      parcel =
        Schemas.Parcel
        |> Repo.one!()
        |> Repo.preload(:transfers)

      assert {:ok, %{transfer: _, update_parcel: updated_parcel}} =
               Transfer.transfer_parcel(parcel, location2)

      assert updated_parcel.is_delivered
      assert updated_parcel.state == :delivered
    end
  end
end

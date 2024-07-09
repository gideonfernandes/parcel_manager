defmodule ParcelManager.Domain.Aggregates.TransferTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Domain.Aggregates.Transfer
  alias ParcelManager.Infrastructure.Persistence.Schemas

  describe "transfer_parcel/2" do
    test "returns error when parcel is already delivered" do
      location = insert(:location)

      parcel =
        insert(:parcel,
          destination_id: location.id,
          destination: location,
          is_delivered: true,
          state: :delivered
        )

      expected_result = {:error, :already_delivered}

      parcel_with_transfers =
        Schemas.Parcel
        |> Repo.get!(parcel.id)
        |> Repo.preload(:transfers)

      assert Transfer.transfer_parcel(parcel_with_transfers, location) == expected_result
    end

    test "returns error when parcel is returning to source" do
      location = insert(:location)
      insert(:parcel, source_id: location.id, source: location)

      parcel =
        Schemas.Parcel
        |> Repo.one!()
        |> Repo.preload(:transfers)

      expected_result = {:error, :cannot_be_returned_to_previous_locations}

      parcel_with_transfers =
        Schemas.Parcel
        |> Repo.get!(parcel.id)
        |> Repo.preload(:transfers)

      assert Transfer.transfer_parcel(parcel_with_transfers, location) == expected_result
    end

    test "returns error when parcel is returning to previous locations" do
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

      expected_result = {:error, :cannot_be_returned_to_previous_locations}

      parcel_with_transfers =
        Schemas.Parcel
        |> Repo.get!(parcel.id)
        |> Repo.preload(:transfers)

      assert Transfer.transfer_parcel(parcel_with_transfers, location2) == expected_result
    end

    test "transfers parcel to location & updates parcel to in_transit" do
      location1 = insert(:location)
      location2 = insert(:location)
      insert(:parcel, destination_id: location1.id, destination: location1)

      parcel =
        Schemas.Parcel
        |> Repo.one!()
        |> Repo.preload(:transfers)

      assert {:ok, %{transfer: _, update_parcel: updated_parcel}} =
               Transfer.transfer_parcel(parcel, location2)

      assert updated_parcel.id == parcel.id
      assert updated_parcel.state == :in_transit
      assert updated_parcel.current_id == location2.id
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

      assert updated_parcel.id == parcel.id
      assert updated_parcel.is_delivered
      assert updated_parcel.state == :delivered
      assert updated_parcel.current_id == location2.id
    end
  end
end

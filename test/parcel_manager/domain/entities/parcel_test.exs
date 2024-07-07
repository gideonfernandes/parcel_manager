defmodule ParcelManager.Domain.Entities.ParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Domain.Entities.Parcel
  alias ParcelManager.Infrastructure.Persistence.Schemas

  describe "destination_arrived?/2" do
    test "refutes when destination has not arrived" do
      location1 = insert(:location)
      location2 = insert(:location)
      parcel = insert(:parcel, destination_id: location1.id, destination: location1)

      refute Parcel.destination_arrived?(parcel, location2)
    end

    test "asserts when destination has arrived" do
      _location1 = insert(:location)
      location2 = insert(:location)
      parcel = insert(:parcel, destination_id: location2.id, destination: location2)

      assert Parcel.destination_arrived?(parcel, location2)
    end
  end

  describe "check_transferability/2" do
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

      assert Parcel.check_transferability(parcel, location) == expected_result
    end

    test "returns error when parcel is returning" do
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

      expected_result = {:error, :cannot_be_returned_to_previous_locations}

      assert Parcel.check_transferability(parcel_with_transfers, location1) == expected_result
    end

    test "returns {:ok, true} when parcel has no previous transfers" do
      location = insert(:location)
      insert(:parcel)

      parcel =
        Schemas.Parcel
        |> Repo.one!()
        |> Repo.preload(:transfers)

      expected_result = {:ok, true}

      assert Parcel.check_transferability(parcel, location) == expected_result
    end

    test "returns {:ok, true} when parcel is transferable" do
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
        |> Repo.one!()
        |> Repo.preload(:transfers)

      expected_result = {:ok, true}

      assert Parcel.check_transferability(parcel_with_transfers, location3) == expected_result
    end
  end
end

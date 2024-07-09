defmodule ParcelManager.Domain.Entities.ParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Domain.Entities.Parcel

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

  describe "check_cancelability/1" do
    test "returns error when parcel state is already canceled" do
      parcel = insert(:parcel, state: :canceled)
      expected_result = {:error, :already_canceled}

      assert Parcel.check_cancelability(parcel) == expected_result
    end

    test "returns error when parcel state is already in transit" do
      parcel = insert(:parcel, state: :in_transit)
      expected_result = {:error, :already_in_transit}

      assert Parcel.check_cancelability(parcel) == expected_result
    end

    test "returns error when parcel state is already delivered" do
      parcel = insert(:parcel, state: :delivered, is_delivered: true)
      expected_result = {:error, :already_delivered}

      assert Parcel.check_cancelability(parcel) == expected_result
    end

    test "returns {:ok, true} when parcel state is pending" do
      parcel = insert(:parcel, state: :pending)
      expected_result = {:ok, true}

      assert Parcel.check_cancelability(parcel) == expected_result
    end
  end

  describe "delivered?/1" do
    for state <- ~w/pending in_transit canceled/a do
      test "refutes when parcel is state is #{state}" do
        parcel = insert(:parcel, state: unquote(state))

        refute Parcel.delivered?(parcel)
      end
    end

    test "asserts when parcel state is delivered" do
      parcel = insert(:parcel, state: :delivered, is_delivered: true)

      assert Parcel.delivered?(parcel)
    end
  end
end

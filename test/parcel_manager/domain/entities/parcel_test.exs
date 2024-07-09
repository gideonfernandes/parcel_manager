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
end

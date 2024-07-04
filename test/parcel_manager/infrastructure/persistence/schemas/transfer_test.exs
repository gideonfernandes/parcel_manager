defmodule ParcelManager.Infrastructure.Persistence.Schemas.TransferTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Schemas.Transfer

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}
      expected_result = %{location_id: ["can't be blank"], parcel_id: ["can't be blank"]}

      changeset = Transfer.changeset(%Transfer{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{location_id: {}, parcel_id: {}}
      expected_result = %{location_id: ["is invalid"], parcel_id: ["is invalid"]}

      changeset = Transfer.changeset(%Transfer{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = params_for(:transfer)

      expected_result = %{
        location_id: attrs.location_id,
        parcel_id: attrs.parcel_id
      }

      changeset = Transfer.changeset(%Transfer{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end
end

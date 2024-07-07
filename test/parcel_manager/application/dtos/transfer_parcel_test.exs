defmodule ParcelManager.Application.Dtos.TransferParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.TransferParcel

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}
      expected_result = %{parcel_id: ["can't be blank"], transfer_location_id: ["can't be blank"]}

      changeset = TransferParcel.changeset(%TransferParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{parcel_id: {}, transfer_location_id: {}}
      expected_result = %{parcel_id: ["is invalid"], transfer_location_id: ["is invalid"]}

      changeset = TransferParcel.changeset(%TransferParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = %{parcel_id: Faker.UUID.v4(), transfer_location_id: Faker.UUID.v4()}

      expected_result = %{
        parcel_id: attrs.parcel_id,
        transfer_location_id: attrs.transfer_location_id
      }

      changeset = TransferParcel.changeset(%TransferParcel{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end

  describe "build/1" do
    test "returns error when missing attrs" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = TransferParcel.build(attrs)
    end

    test "returns error when invalid type attrs" do
      attrs = %{parcel_id: {}, transfer_location_id: {}}

      assert {:error, %Ecto.Changeset{}} = TransferParcel.build(attrs)
    end

    test "builds when given all attrs" do
      attrs = %{parcel_id: Faker.UUID.v4(), transfer_location_id: Faker.UUID.v4()}
      expected_result = {:ok, struct!(TransferParcel, attrs)}

      assert TransferParcel.build(attrs) == expected_result
    end
  end
end

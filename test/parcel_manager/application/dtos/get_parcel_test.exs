defmodule ParcelManager.Application.Dtos.GetParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.GetParcel

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}
      expected_result = %{parcel_id: ["can't be blank"]}

      changeset = GetParcel.changeset(%GetParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{parcel_id: {}}
      expected_result = %{parcel_id: ["is invalid"]}

      changeset = GetParcel.changeset(%GetParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = %{parcel_id: Faker.UUID.v4()}
      expected_result = %{parcel_id: attrs.parcel_id}

      changeset = GetParcel.changeset(%GetParcel{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end

  describe "build/1" do
    test "returns error when missing attrs" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = GetParcel.build(attrs)
    end

    test "returns error when invalid type attrs" do
      attrs = %{parcel_id: {}}

      assert {:error, %Ecto.Changeset{}} = GetParcel.build(attrs)
    end

    test "builds when given all attrs" do
      attrs = %{parcel_id: Faker.UUID.v4()}
      expected_result = {:ok, struct!(GetParcel, attrs)}

      assert GetParcel.build(attrs) == expected_result
    end
  end
end

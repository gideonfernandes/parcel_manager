defmodule ParcelManager.Application.Dtos.CreateParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.CreateParcel

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}

      expected_result = %{
        description: ["can't be blank"],
        source_id: ["can't be blank"],
        destination_id: ["can't be blank"]
      }

      changeset = CreateParcel.changeset(%CreateParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{description: {}, source_id: {}, destination_id: {}}

      expected_result = %{
        description: ["is invalid"],
        source_id: ["is invalid"],
        destination_id: ["is invalid"]
      }

      changeset = CreateParcel.changeset(%CreateParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = params_for(:create_parcel_dto)

      expected_result = %{
        description: attrs.description,
        source_id: attrs.source_id,
        destination_id: attrs.destination_id
      }

      changeset = CreateParcel.changeset(%CreateParcel{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end

  describe "build/1" do
    test "returns error when missing attrs" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = CreateParcel.build(attrs)
    end

    test "returns error when invalid type attrs" do
      attrs = %{description: {}, source_id: {}, destination_id: {}}

      assert {:error, %Ecto.Changeset{}} = CreateParcel.build(attrs)
    end

    test "builds when given all attrs" do
      attrs = params_for(:create_parcel_dto)
      expected_result = {:ok, struct!(CreateParcel, attrs)}

      assert CreateParcel.build(attrs) == expected_result
    end
  end
end

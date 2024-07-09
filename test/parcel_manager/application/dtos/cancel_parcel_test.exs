defmodule ParcelManager.Application.Dtos.CancelParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.CancelParcel

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}

      expected_result = %{
        parcel_id: ["can't be blank"],
        reason: ["can't be blank"]
      }

      changeset = CancelParcel.changeset(%CancelParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{parcel_id: {}, reason: {}}

      expected_result = %{
        parcel_id: ["is invalid"],
        reason: ["is invalid"]
      }

      changeset = CancelParcel.changeset(%CancelParcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = params_for(:cancel_parcel_dto)

      expected_result = %{
        parcel_id: attrs.parcel_id,
        reason: attrs.reason
      }

      changeset = CancelParcel.changeset(%CancelParcel{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end

  describe "build/1" do
    test "returns error when missing attrs" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = CancelParcel.build(attrs)
    end

    test "returns error when invalid type attrs" do
      attrs = %{parcel_id: {}, reason: {}}

      assert {:error, %Ecto.Changeset{}} = CancelParcel.build(attrs)
    end

    test "builds when given all attrs" do
      attrs = params_for(:cancel_parcel_dto)
      expected_result = {:ok, struct!(CancelParcel, attrs)}

      assert CancelParcel.build(attrs) == expected_result
    end
  end
end

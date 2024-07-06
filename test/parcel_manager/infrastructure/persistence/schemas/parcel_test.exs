defmodule ParcelManager.Infrastructure.Persistence.Schemas.ParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Schemas.Parcel

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}

      expected_result = %{
        description: ["can't be blank"],
        destination_id: ["can't be blank"],
        source_id: ["can't be blank"]
      }

      changeset = Parcel.changeset(%Parcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{
        description: {},
        is_delivered: {},
        state: {},
        reason: {},
        destination_id: {},
        source_id: {}
      }

      expected_result = %{
        description: ["is invalid"],
        destination_id: ["is invalid"],
        source_id: ["is invalid"],
        is_delivered: ["is invalid"],
        reason: ["is invalid"],
        state: ["is invalid"]
      }

      changeset = Parcel.changeset(%Parcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid state" do
      attrs = params_for(:parcel, state: :invalid)

      expected_result = %{state: ["is invalid"]}

      changeset = Parcel.changeset(%Parcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when source & destination are the same" do
      source = insert(:location)
      attrs = params_for(:parcel, source_id: source.id, destination_id: source.id)

      expected_result = %{destination_id: ["must be different from source_id"]}

      changeset = Parcel.changeset(%Parcel{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given the required attrs" do
      attrs = params_for(:parcel)

      expected_result = %{
        description: attrs.description,
        destination_id: attrs.destination_id,
        source_id: attrs.source_id
      }

      changeset = Parcel.changeset(%Parcel{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = params_for(:parcel, is_delivered: true, state: :in_transit, reason: "reason")

      expected_result = %{
        description: attrs.description,
        destination_id: attrs.destination_id,
        is_delivered: attrs.is_delivered,
        reason: attrs.reason,
        source_id: attrs.source_id,
        state: attrs.state
      }

      changeset = Parcel.changeset(%Parcel{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end
end

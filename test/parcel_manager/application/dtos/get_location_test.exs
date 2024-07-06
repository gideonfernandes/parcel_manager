defmodule ParcelManager.Application.Dtos.GetLocationTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.GetLocation

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}
      expected_result = %{location_id: ["can't be blank"]}

      changeset = GetLocation.changeset(%GetLocation{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{location_id: {}}
      expected_result = %{location_id: ["is invalid"]}

      changeset = GetLocation.changeset(%GetLocation{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = %{location_id: Faker.UUID.v4()}
      expected_result = %{location_id: attrs.location_id}

      changeset = GetLocation.changeset(%GetLocation{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end

  describe "build/1" do
    test "returns error when missing attrs" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = GetLocation.build(attrs)
    end

    test "returns error when invalid type attrs" do
      attrs = %{location_id: {}}

      assert {:error, %Ecto.Changeset{}} = GetLocation.build(attrs)
    end

    test "builds when given all attrs" do
      attrs = %{location_id: Faker.UUID.v4()}
      expected_result = {:ok, struct!(GetLocation, attrs)}

      assert GetLocation.build(attrs) == expected_result
    end
  end
end

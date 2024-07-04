defmodule ParcelManager.Infrastructure.Persistence.Schemas.LocationTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Schemas.Location

  describe "changeset/2" do
    test "returns an invalid changeset when missing attrs" do
      attrs = %{}
      expected_result = %{name: ["can't be blank"]}

      changeset = Location.changeset(%Location{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns an invalid changeset when invalid type attrs" do
      attrs = %{name: {}}
      expected_result = %{name: ["is invalid"]}

      changeset = Location.changeset(%Location{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == expected_result
    end

    test "returns a valid changeset when given all attrs" do
      attrs = params_for(:location)

      expected_result = %{name: attrs.name}

      changeset = Location.changeset(%Location{}, attrs)

      assert changeset.valid?
      assert changeset.changes == expected_result
    end
  end
end

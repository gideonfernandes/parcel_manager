defmodule ParcelManager.Application.UseCases.GetLocationTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.GetLocation
  alias ParcelManager.Application.UseCases.GetLocation

  describe "call/1" do
    test "returns error when location is not found" do
      dto = build(:get_location_dto)

      log =
        capture_log(fn ->
          assert {:error, :location_not_found} = GetLocation.call(dto)
        end)

      assert log =~ "[info] #{GetLocation}.call location_id=#{dto.location_id}"
    end

    test "reads location data" do
      location = insert(:location)
      dto = build(:get_location_dto, location_id: location.id)

      expected_result =
        {:ok,
         %{
           id: location.id,
           name: location.name,
           source_parcels: [],
           destination_parcels: []
         }}

      log =
        capture_log(fn ->
          assert GetLocation.call(dto) == expected_result
        end)

      assert log =~ "[info] #{GetLocation}.call location_id=#{dto.location_id}"
    end
  end
end

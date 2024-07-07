defmodule ParcelManager.Infrastructure.Persistence.Repositories.LocationRepositoryTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Repositories.LocationRepository

  describe "get/1" do
    test "returns nil when location is not found" do
      assert nil == LocationRepository.get(Faker.UUID.v4())
    end

    test "reads a location selecting without current parcels" do
      location = insert(:location)
      expected_result = %{id: location.id, name: location.name, current_parcels: []}

      assert LocationRepository.get(location.id) == expected_result
    end

    test "reads a location selecting current parcels" do
      location = insert(:location)
      _parcel1 = insert(:parcel, source: location)
      parcel2 = insert(:parcel, current: location)
      parcel3 = insert(:parcel, current: location)
      _parcel4 = insert(:parcel, destination: location)

      expected_result = %{
        id: location.id,
        name: location.name,
        current_parcels: [
          %{
            id: parcel2.id,
            description: parcel2.description,
            is_delivered: parcel2.is_delivered,
            source_id: parcel2.source.id,
            destination_id: parcel2.destination.id,
            source: %{
              id: parcel2.source.id,
              name: parcel2.source.name
            },
            destination: %{
              id: parcel2.destination.id,
              name: parcel2.destination.name
            }
          },
          %{
            id: parcel3.id,
            description: parcel3.description,
            is_delivered: parcel3.is_delivered,
            source_id: parcel3.source.id,
            destination_id: parcel3.destination.id,
            source: %{
              id: parcel3.source.id,
              name: parcel3.source.name
            },
            destination: %{
              id: parcel3.destination.id,
              name: parcel3.destination.name
            }
          }
        ]
      }

      assert LocationRepository.get(location.id) == expected_result
    end
  end
end

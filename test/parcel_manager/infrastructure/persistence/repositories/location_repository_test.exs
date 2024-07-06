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

      expected_result = %{
        id: location.id,
        name: location.name,
        source_parcels: [],
        destination_parcels: []
      }

      assert LocationRepository.get(location.id) == expected_result
    end

    test "reads a location selecting current source parcels" do
      location = insert(:location)

      parcel1 =
        insert(:parcel,
          source_id: location.id,
          source: location
        )

      parcel2 =
        insert(:parcel,
          source_id: location.id,
          source: location
        )

      expected_result = %{
        id: location.id,
        name: location.name,
        source_parcels: [
          %{
            id: parcel1.id,
            description: parcel1.description,
            is_delivered: parcel1.is_delivered,
            source_id: parcel1.source.id,
            destination_id: parcel1.destination.id,
            source: %{
              id: location.id,
              name: location.name
            },
            destination: %{
              id: parcel1.destination.id,
              name: parcel1.destination.name
            }
          },
          %{
            id: parcel2.id,
            description: parcel2.description,
            is_delivered: parcel2.is_delivered,
            source_id: parcel2.source.id,
            destination_id: parcel2.destination.id,
            source: %{
              id: location.id,
              name: location.name
            },
            destination: %{
              id: parcel2.destination.id,
              name: parcel2.destination.name
            }
          }
        ],
        destination_parcels: []
      }

      assert LocationRepository.get(location.id) == expected_result
    end

    test "reads a location selecting current destination parcels" do
      location = insert(:location)

      parcel1 =
        insert(:parcel,
          destination_id: location.id,
          destination: location,
          state: :delivered
        )

      parcel2 =
        insert(:parcel,
          destination_id: location.id,
          destination: location,
          state: :delivered
        )

      expected_result = %{
        id: location.id,
        name: location.name,
        source_parcels: [],
        destination_parcels: [
          %{
            id: parcel1.id,
            description: parcel1.description,
            is_delivered: parcel1.is_delivered,
            source_id: parcel1.source.id,
            destination_id: parcel1.destination.id,
            source: %{
              id: parcel1.source.id,
              name: parcel1.source.name
            },
            destination: %{
              id: location.id,
              name: location.name
            }
          },
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
              id: location.id,
              name: location.name
            }
          }
        ]
      }

      assert LocationRepository.get(location.id) == expected_result
    end
  end
end

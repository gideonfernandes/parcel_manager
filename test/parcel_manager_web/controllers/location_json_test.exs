defmodule ParcelManagerWeb.LocationJSONTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManagerWeb.LocationJSON

  test "renders show.json" do
    location = insert(:location)

    parcel =
      insert(:parcel,
        source_id: location.id,
        source: location
      )

    {:ok, loaded_location} = ParcelManager.get_location(%{"location_id" => location.id})

    attrs = %{location: loaded_location}

    expected_result = %{
      data: %{
        id: location.id,
        name: location.name,
        parcels: [
          %{
            id: parcel.id,
            description: parcel.description,
            is_delivered: parcel.is_delivered,
            source_id: parcel.source.id,
            destination_id: parcel.destination.id,
            source: %{id: location.id, name: location.name},
            destination: %{id: parcel.destination.id, name: parcel.destination.name}
          }
        ]
      }
    }

    assert LocationJSON.render("show.json", attrs) == expected_result
  end
end

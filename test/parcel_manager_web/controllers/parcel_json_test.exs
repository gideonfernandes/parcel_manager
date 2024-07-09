defmodule ParcelManagerWeb.ParcelJSONTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManagerWeb.ParcelJSON

  test "renders created.json" do
    attrs = %{parcel: %{id: Faker.UUID.v4()}}
    expected_result = %{data: %{id: attrs.parcel.id}}

    assert ParcelJSON.render("created.json", attrs) == expected_result
  end

  test "renders transfer.json" do
    attrs = %{
      transfer: %{
        id: Faker.UUID.v4(),
        parcel_id: Faker.UUID.v4(),
        location_id: Faker.UUID.v4()
      }
    }

    expected_result = %{
      data: %{
        transfer_id: attrs.transfer.id,
        parcel_id: attrs.transfer.parcel_id,
        location_id: attrs.transfer.location_id
      }
    }

    assert ParcelJSON.render("transfer.json", attrs) == expected_result
  end

  test "renders cancel.json" do
    attrs = %{canceled_parcel: %{id: Faker.UUID.v4()}}
    expected_result = %{data: %{id: attrs.canceled_parcel.id}}

    assert ParcelJSON.render("cancel.json", attrs) == expected_result
  end

  test "renders show.json" do
    location1 = insert(:location)
    location2 = insert(:location)
    location3 = insert(:location)
    parcel = insert(:parcel)

    insert(:transfer,
      parcel_id: parcel.id,
      parcel: parcel,
      location: location3,
      location_id: location3.id
    )

    insert(:transfer,
      parcel_id: parcel.id,
      parcel: parcel,
      location: location2,
      location_id: location2.id
    )

    insert(:transfer,
      parcel_id: parcel.id,
      parcel: parcel,
      location: location1,
      location_id: location1.id
    )

    {:ok, loaded_parcel} = ParcelManager.get_parcel(%{"parcel_id" => parcel.id})

    attrs = %{parcel: loaded_parcel}

    expected_result = %{
      data: %{
        id: parcel.id,
        description: parcel.description,
        source: %{id: parcel.source.id, name: parcel.source.name},
        destination: %{id: parcel.destination.id, name: parcel.destination.name},
        is_delivered: parcel.is_delivered,
        locations: [
          %{id: parcel.source.id, name: parcel.source.name},
          %{id: location3.id, name: location3.name},
          %{id: location2.id, name: location2.name},
          %{id: location1.id, name: location1.name}
        ],
        reason: parcel.reason,
        state: parcel.state
      }
    }

    assert ParcelJSON.render("show.json", attrs) == expected_result
  end
end

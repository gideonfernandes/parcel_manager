defmodule ParcelManagerWeb.LocationControllerTest do
  @moduledoc false

  use ParcelManagerWeb.ConnCase, async: true

  import ParcelManager.Factory

  describe "show/2" do
    test "returns traversed changesed errors when missing params", %{conn: conn} do
      expected_response = %{"reason" => %{"location_id" => ["can't be blank"]}}

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/location/ ")
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/location"
      assert log =~ "[info] Sent 400"
    end

    test "returns traversed changesed errors when invalid type params", %{conn: conn} do
      params = string_params_for(:get_location_dto, location_id: %{})

      expected_response = %{"reason" => %{"location_id" => ["is invalid"]}}

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/location/:location_id", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/location"
      assert log =~ "[info] Sent 400"
    end

    test "returns error when location is not found", %{conn: conn} do
      params = string_params_for(:get_location_dto, location_id: Faker.UUID.v4())

      expected_response = %{"reason" => "location not found"}

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/location/#{params["location_id"]}")
            |> json_response(:not_found)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/location"
      assert log =~ "[info] Sent 404"
    end

    test "reads location data with current parcels", %{conn: conn} do
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

      parcel3 =
        insert(:parcel,
          destination_id: location.id,
          destination: location,
          state: :delivered
        )

      parcel4 =
        insert(:parcel,
          destination_id: location.id,
          destination: location,
          state: :delivered
        )

      params = string_params_for(:get_location_dto, location_id: location.id)

      expected_response = %{
        "data" => %{
          "id" => location.id,
          "name" => location.name,
          "parcels" => [
            %{
              "id" => parcel1.id,
              "description" => parcel1.description,
              "is_delivered" => parcel1.is_delivered,
              "source_id" => parcel1.source.id,
              "destination_id" => parcel1.destination.id,
              "source" => %{
                "id" => location.id,
                "name" => location.name
              },
              "destination" => %{
                "id" => parcel1.destination.id,
                "name" => parcel1.destination.name
              }
            },
            %{
              "id" => parcel2.id,
              "description" => parcel2.description,
              "is_delivered" => parcel2.is_delivered,
              "source_id" => parcel2.source.id,
              "destination_id" => parcel2.destination.id,
              "source" => %{
                "id" => location.id,
                "name" => location.name
              },
              "destination" => %{
                "id" => parcel2.destination.id,
                "name" => parcel2.destination.name
              }
            },
            %{
              "id" => parcel3.id,
              "description" => parcel3.description,
              "is_delivered" => parcel3.is_delivered,
              "source_id" => parcel3.source.id,
              "destination_id" => parcel3.destination.id,
              "source" => %{
                "id" => parcel3.source.id,
                "name" => parcel3.source.name
              },
              "destination" => %{
                "id" => location.id,
                "name" => location.name
              }
            },
            %{
              "id" => parcel4.id,
              "description" => parcel4.description,
              "is_delivered" => parcel4.is_delivered,
              "source_id" => parcel4.source.id,
              "destination_id" => parcel4.destination.id,
              "source" => %{
                "id" => parcel4.source.id,
                "name" => parcel4.source.name
              },
              "destination" => %{
                "id" => location.id,
                "name" => location.name
              }
            }
          ]
        }
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/location/#{params["location_id"]}")
            |> json_response(:ok)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/location"
      assert log =~ "[info] Sent 200"
    end

    test "reads location data without current parcels", %{conn: conn} do
      location = insert(:location)
      params = string_params_for(:get_location_dto, location_id: location.id)

      expected_response = %{
        "data" => %{
          "id" => location.id,
          "name" => location.name,
          "parcels" => []
        }
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/location/#{params["location_id"]}")
            |> json_response(:ok)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/location"
      assert log =~ "[info] Sent 200"
    end
  end
end

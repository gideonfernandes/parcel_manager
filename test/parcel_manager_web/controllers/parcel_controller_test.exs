defmodule ParcelManagerWeb.ParcelControllerTest do
  @moduledoc false

  use ParcelManagerWeb.ConnCase, async: true

  import ParcelManager.Factory

  describe "create/2" do
    test "returns traversed changesed errors when missing params", %{conn: conn} do
      params = %{}

      expected_response = %{
        "reason" => %{
          "description" => ["can't be blank"],
          "destination_id" => ["can't be blank"],
          "source_id" => ["can't be blank"]
        }
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcels", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcels"
      assert log =~ "[info] Sent 400"
    end

    test "returns traversed changesed errors when invalid type params", %{conn: conn} do
      params =
        string_params_for(:create_parcel_dto,
          description: {},
          destination_id: {},
          source_id: {}
        )

      expected_response = %{
        "reason" => %{
          "description" => ["is invalid"],
          "destination_id" => ["is invalid"],
          "source_id" => ["is invalid"]
        }
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcels", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcels"
      assert log =~ "[info] Sent 400"
    end

    test "returns traversed changesed error when source & destination are the same", %{conn: conn} do
      source = insert(:location)

      params =
        string_params_for(:create_parcel_dto, source_id: source.id, destination_id: source.id)

      expected_response = %{
        "reason" => %{"destination_id" => ["must be different from source_id"]}
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcels", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcels"
      assert log =~ "[info] Sent 400"
    end

    test "creates parcel", %{conn: conn} do
      source = insert(:location)
      destination = insert(:location)

      params =
        string_params_for(:create_parcel_dto, source_id: source.id, destination_id: destination.id)

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcels", params)
            |> json_response(:created)

          assert %{
                   "data" => %{
                     "id" => _
                   }
                 } = response

          Repo.get!(Schemas.Parcel, response["data"]["id"])
        end)

      assert log =~ "[info] POST /api/parcels"
      assert log =~ "[info] Sent 201"
    end
  end
end

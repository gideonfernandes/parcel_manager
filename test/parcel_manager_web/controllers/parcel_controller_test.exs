defmodule ParcelManagerWeb.ParcelControllerTest do
  @moduledoc false

  use ParcelManagerWeb.ConnCase, async: true

  import ParcelManager.Factory

  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker

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
            |> post(~p"/api/parcel", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
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
            |> post(~p"/api/parcel", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
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
            |> post(~p"/api/parcel", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
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
            |> post(~p"/api/parcel", params)
            |> json_response(:created)

          assert %{
                   "data" => %{
                     "id" => _
                   }
                 } = response

          Repo.get!(Schemas.Parcel, response["data"]["id"])
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 201"
    end
  end

  describe "show/2" do
    test "returns traversed changesed errors when missing params", %{conn: conn} do
      expected_response = %{"reason" => %{"parcel_id" => ["can't be blank"]}}

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/parcel/ ")
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/parcel"
      assert log =~ "[info] Sent 400"
    end

    test "returns traversed changesed errors when invalid type params", %{conn: conn} do
      params = string_params_for(:get_parcel_dto, parcel_id: %{})
      expected_response = %{"reason" => %{"parcel_id" => ["is invalid"]}}

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/parcel/:parcel_id", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/parcel"
      assert log =~ "[info] Sent 400"
    end

    test "returns error when parcel is not found", %{conn: conn} do
      params = string_params_for(:get_parcel_dto, parcel_id: Faker.UUID.v4())
      expected_response = %{"reason" => "parcel not found"}

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/parcel/#{params["parcel_id"]}")
            |> json_response(:not_found)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/parcel"
      assert log =~ "[info] Sent 404"
    end

    test "reads parcel data", %{conn: conn} do
      location1 = insert(:location)
      location2 = insert(:location)
      location3 = insert(:location)
      parcel = insert(:parcel)

      insert(:transfer,
        parcel_id: parcel.id,
        parcel: parcel,
        location: location1,
        location_id: location1.id
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
        location: location3,
        location_id: location3.id
      )

      params = string_params_for(:get_parcel_dto, parcel_id: parcel.id)

      expected_response = %{
        "data" => %{
          "id" => parcel.id,
          "description" => parcel.description,
          "is_delivered" => parcel.is_delivered,
          "state" => Atom.to_string(parcel.state),
          "reason" => parcel.reason,
          "source" => %{
            "id" => parcel.source.id,
            "name" => parcel.source.name
          },
          "locations" => [
            %{"id" => parcel.source.id, "name" => parcel.source.name},
            %{"id" => location1.id, "name" => location1.name},
            %{"id" => location2.id, "name" => location2.name},
            %{"id" => location3.id, "name" => location3.name}
          ],
          "destination" => %{
            "id" => parcel.destination.id,
            "name" => parcel.destination.name
          }
        }
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> get(~p"/api/parcel/#{params["parcel_id"]}")
            |> json_response(:ok)

          assert response == expected_response
        end)

      assert log =~ "[info] GET /api/parcel"
      assert log =~ "[info] Sent 200"
    end
  end

  describe "transfer/2" do
    test "returns traversed changesed errors when missing params", %{conn: conn} do
      params = %{}

      expected_response = %{
        "reason" => %{
          "parcel_id" => ["can't be blank"],
          "transfer_location_id" => ["can't be blank"]
        }
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/ /transfer", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 400"
    end

    test "returns traversed changesed errors when invalid type params", %{conn: conn} do
      params = %{"transfer_location_id" => {}}

      expected_response = %{
        "reason" => %{"parcel_id" => ["is invalid"], "transfer_location_id" => ["is invalid"]}
      }

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/{}/transfer", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 400"
    end

    test "returns error when parcel is not found", %{conn: conn} do
      params = string_params_for(:transfer_parcel_dto)
      expected_response = %{"reason" => "parcel not found"}

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/#{params["parcel_id"]}/transfer", params)
            |> json_response(:not_found)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 404"
    end

    test "returns error when location is not found", %{conn: conn} do
      parcel = insert(:parcel)
      params = string_params_for(:transfer_parcel_dto, parcel_id: parcel.id)
      expected_response = %{"reason" => "location not found"}

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/#{parcel.id}/transfer", params)
            |> json_response(:not_found)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 404"
    end

    test "returns error when parcel is not transferable", %{conn: conn} do
      location1 = insert(:location)
      location2 = insert(:location)
      location3 = insert(:location)
      _location4 = insert(:location)
      parcel = insert(:parcel, destination_id: location3.id, destination: location3)

      insert(:transfer,
        location_id: location1.id,
        location: location1,
        parcel_id: parcel.id,
        parcel: parcel
      )

      insert(:transfer,
        location_id: location2.id,
        location: location2,
        parcel_id: parcel.id,
        parcel: parcel
      )

      params =
        string_params_for(:transfer_parcel_dto,
          parcel_id: parcel.id,
          transfer_location_id: location2.id
        )

      expected_response = %{"reason" => "parcel cannot be returned to previous locations"}

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/#{parcel.id}/transfer", params)
            |> json_response(:bad_request)

          assert response == expected_response
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 400"
    end

    test "transfers parcel to location skipping parcel updating to deliver", %{conn: conn} do
      _location1 = insert(:location)
      %{id: location2_id} = insert(:location)
      location3 = insert(:location)
      _location4 = insert(:location)
      %{id: parcel_id} = insert(:parcel, destination_id: location3.id, destination: location3)

      params =
        string_params_for(:transfer_parcel_dto,
          parcel_id: parcel_id,
          transfer_location_id: location2_id
        )

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/#{parcel_id}/transfer", params)
            |> json_response(:created)

          assert %{
                   "data" => %{
                     "location_id" => ^location2_id,
                     "parcel_id" => ^parcel_id,
                     "transfer_id" => _
                   }
                 } = response

          refute_enqueued(worker: SenderWorker)
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 201"
    end

    test "transfers parcel to location, updates parcel & send email", %{conn: conn} do
      _location1 = insert(:location)
      _location2 = insert(:location)
      %{id: location3_id} = location3 = insert(:location)
      _location4 = insert(:location)
      %{id: parcel_id} = insert(:parcel, destination_id: location3_id, destination: location3)

      params =
        string_params_for(:transfer_parcel_dto,
          parcel_id: parcel_id,
          transfer_location_id: location3_id
        )

      log =
        capture_log(fn ->
          response =
            conn
            |> post(~p"/api/parcel/#{parcel_id}/transfer", params)
            |> json_response(:created)

          assert %{
                   "data" => %{
                     "location_id" => ^location3_id,
                     "parcel_id" => ^parcel_id,
                     "transfer_id" => transfer_id
                   }
                 } = response

          assert_enqueued(
            worker: SenderWorker,
            args: %{"message" => "Parcel is delivered sucessfully!"}
          )
        end)

      assert log =~ "[info] POST /api/parcel"
      assert log =~ "[info] Sent 201"
    end
  end
end

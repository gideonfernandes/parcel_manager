defmodule ParcelManagerTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager
  alias ParcelManager.Application.Error

  describe "create_parcel/1" do
    test "returns error struct when undesired result" do
      params = %{}

      assert {:error, %Error{result: _changeset, status: _status}} =
               ParcelManager.create_parcel(params)
    end

    test "builds dto from params & creates parcel" do
      source = insert(:location)
      destination = insert(:location)

      params =
        string_params_for(:create_parcel_dto, source_id: source.id, destination_id: destination.id)

      assert {:ok, _} = ParcelManager.create_parcel(params)
    end
  end

  describe "get_parcel/1" do
    test "returns error struct when undesired result" do
      params = %{}

      assert {:error, %Error{result: _changeset, status: _status}} =
               ParcelManager.get_parcel(params)
    end

    test "builds dto from params & reads parcel data" do
      parcel = insert(:parcel)
      params = string_params_for(:get_parcel_dto, parcel_id: parcel.id)

      assert {:ok, _} = ParcelManager.get_parcel(params)
    end
  end

  describe "get_location/1" do
    test "returns error struct when undesired result" do
      params = %{}

      assert {:error, %Error{result: _changeset, status: _status}} =
               ParcelManager.get_location(params)
    end

    test "builds dto from params & reads location data" do
      location = insert(:location)
      params = string_params_for(:get_location_dto, location_id: location.id)

      assert {:ok, _} = ParcelManager.get_location(params)
    end
  end
end

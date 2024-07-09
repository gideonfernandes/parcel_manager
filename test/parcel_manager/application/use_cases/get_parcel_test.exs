defmodule ParcelManager.Application.UseCases.GetParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Dtos.GetParcel
  alias ParcelManager.Application.Error
  alias ParcelManager.Application.UseCases.GetParcel

  describe "call/1" do
    test "returns error when parcel is not found" do
      dto = build(:get_parcel_dto)
      expected_result = {:error, %Error{result: "parcel not found", status: :not_found}}

      log =
        capture_log(fn ->
          assert GetParcel.call(dto) == expected_result
        end)

      assert log =~ "[info] #{GetParcel}.call parcel_id=#{dto.parcel_id}"
      assert log =~ "[error] #{GetParcel}.call :parcel_not_found"
    end

    test "reads parcel data" do
      parcel = insert(:parcel)
      dto = build(:get_parcel_dto, parcel_id: parcel.id)

      expected_result =
        {:ok,
         %{
           id: parcel.id,
           description: parcel.description,
           is_delivered: parcel.is_delivered,
           state: parcel.state,
           reason: parcel.reason,
           source_id: parcel.source_id,
           source: %{
             id: parcel.source.id,
             name: parcel.source.name
           },
           transfers: [],
           destination_id: parcel.destination_id,
           destination: %{
             id: parcel.destination.id,
             name: parcel.destination.name
           }
         }}

      log =
        capture_log(fn ->
          assert GetParcel.call(dto) == expected_result
        end)

      assert log =~ "[info] #{GetParcel}.call parcel_id=#{dto.parcel_id}"
    end
  end
end

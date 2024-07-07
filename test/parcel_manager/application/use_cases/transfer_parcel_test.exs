defmodule ParcelManager.Application.UseCases.TransferParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Error
  alias ParcelManager.Application.UseCases.TransferParcel
  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker

  describe "call/1" do
    test "returns error when parcel is not found" do
      dto = build(:transfer_parcel_dto)
      expected_result = {:error, %Error{result: "parcel not found", status: :not_found}}

      log =
        capture_log(fn ->
          assert TransferParcel.call(dto) == expected_result
        end)

      assert log =~
               "[info] #{TransferParcel}.call parcel_id=#{dto.parcel_id} transfer_location_id=#{dto.transfer_location_id}"
    end

    test "returns error when location is not found" do
      parcel = insert(:parcel)
      dto = build(:transfer_parcel_dto, parcel_id: parcel.id)
      expected_result = {:error, %Error{result: "location not found", status: :not_found}}

      log =
        capture_log(fn ->
          assert TransferParcel.call(dto) == expected_result
        end)

      assert log =~
               "[info] #{TransferParcel}.call parcel_id=#{dto.parcel_id} transfer_location_id=#{dto.transfer_location_id}"
    end

    test "returns error when parcel is not transferable" do
      location1 = insert(:location)
      location2 = insert(:location)
      location3 = insert(:location)
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

      dto = build(:transfer_parcel_dto, parcel_id: parcel.id, transfer_location_id: location2.id)

      expected_result =
        {:error,
         %Error{result: "parcel cannot be returned to previous locations", status: :bad_request}}

      log =
        capture_log(fn ->
          assert TransferParcel.call(dto) == expected_result
        end)

      assert log =~
               "[info] #{TransferParcel}.call parcel_id=#{dto.parcel_id} transfer_location_id=#{dto.transfer_location_id}"
    end

    test "transfers parcel to location & updates parcel to deliver" do
      location1 = insert(:location)
      location2 = insert(:location)
      parcel = insert(:parcel, destination_id: location1.id, destination: location1)
      dto = build(:transfer_parcel_dto, parcel_id: parcel.id, transfer_location_id: location2.id)

      log =
        capture_log(fn ->
          assert {:ok, result} = TransferParcel.call(dto)

          refute is_nil(result.parcel.id)
          refute is_nil(result.location.id)
          refute is_nil(result.transfer_parcel.transfer.id)
          assert result.transfer_parcel.transfer.parcel_id == dto.parcel_id
          assert result.transfer_parcel.transfer.location_id == dto.transfer_location_id
          assert result.transfer_parcel.update_parcel.state == :in_transit
          assert result.sent_email == :skipped

          refute_enqueued(worker: SenderWorker)
        end)

      assert log =~
               "[info] #{TransferParcel}.call parcel_id=#{dto.parcel_id} transfer_location_id=#{dto.transfer_location_id}"
    end

    test "transfers parcel to location, updates parcel & send email" do
      _location1 = insert(:location)
      location2 = insert(:location)
      parcel = insert(:parcel, destination_id: location2.id, destination: location2)
      dto = build(:transfer_parcel_dto, parcel_id: parcel.id, transfer_location_id: location2.id)

      log =
        capture_log(fn ->
          assert {:ok, result} = TransferParcel.call(dto)

          refute is_nil(result.parcel.id)
          refute is_nil(result.location.id)
          refute is_nil(result.transfer_parcel.transfer.id)
          assert result.transfer_parcel.transfer.parcel_id == dto.parcel_id
          assert result.transfer_parcel.transfer.location_id == dto.transfer_location_id
          assert result.transfer_parcel.update_parcel.id == dto.parcel_id
          assert result.transfer_parcel.update_parcel.is_delivered
          assert result.transfer_parcel.update_parcel.state == :delivered
          assert %Oban.Job{} = result.sent_email

          assert_enqueued(
            worker: SenderWorker,
            args: %{"message" => "Parcel is delivered sucessfully!"}
          )
        end)

      assert log =~
               "[info] #{TransferParcel}.call parcel_id=#{dto.parcel_id} transfer_location_id=#{dto.transfer_location_id}"
    end
  end
end

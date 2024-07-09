defmodule ParcelManager.Application.UseCases.CancelParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Error
  alias ParcelManager.Application.UseCases.CancelParcel
  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker

  describe "call/1" do
    test "returns error when parcel is not found" do
      dto = build(:cancel_parcel_dto)
      expected_result = {:error, %Error{result: "parcel not found", status: :not_found}}

      log =
        capture_log(fn ->
          assert CancelParcel.call(dto) == expected_result
          refute_enqueued(worker: SenderWorker)
        end)

      assert log =~ "[info] #{CancelParcel}.call parcel_id=#{dto.parcel_id}"
    end

    test "returns error when parcel is already canceled" do
      parcel = insert(:parcel, state: :canceled)
      dto = build(:cancel_parcel_dto, parcel_id: parcel.id)

      expected_result =
        {:error, %Error{result: "parcel is already canceled", status: :bad_request}}

      log =
        capture_log(fn ->
          assert CancelParcel.call(dto) == expected_result
          refute_enqueued(worker: SenderWorker)
        end)

      assert log =~ "[info] #{CancelParcel}.call parcel_id=#{dto.parcel_id}"
    end

    test "returns error when parcel is already in transit" do
      parcel = insert(:parcel, state: :in_transit)
      dto = build(:cancel_parcel_dto, parcel_id: parcel.id)

      expected_result =
        {:error, %Error{result: "parcel is already in transit", status: :bad_request}}

      log =
        capture_log(fn ->
          assert CancelParcel.call(dto) == expected_result
          refute_enqueued(worker: SenderWorker)
        end)

      assert log =~ "[info] #{CancelParcel}.call parcel_id=#{dto.parcel_id}"
    end

    test "returns error when parcel is already delivered" do
      parcel = insert(:parcel, state: :delivered, is_delivered: true)
      dto = build(:cancel_parcel_dto, parcel_id: parcel.id)

      expected_result =
        {:error, %Error{result: "parcel is already delivered", status: :bad_request}}

      log =
        capture_log(fn ->
          assert CancelParcel.call(dto) == expected_result
          refute_enqueued(worker: SenderWorker)
        end)

      assert log =~ "[info] #{CancelParcel}.call parcel_id=#{dto.parcel_id}"
    end

    test "cancels parcel, persists reason & send cancellation email" do
      parcel = insert(:parcel, state: :pending)
      dto = build(:cancel_parcel_dto, parcel_id: parcel.id)

      log =
        capture_log(fn ->
          assert {:ok, %{cancel_parcel: canceled_parcel, email: email}} = CancelParcel.call(dto)
          assert canceled_parcel.id == dto.parcel_id
          assert canceled_parcel.state == :canceled
          assert canceled_parcel.reason == dto.reason
          assert %Oban.Job{} = email

          assert_enqueued(
            worker: SenderWorker,
            args: %{"message" => "Parcel is canceled sucessfully!"}
          )
        end)

      assert log =~ "[info] #{CancelParcel}.call parcel_id=#{dto.parcel_id}"
    end
  end
end

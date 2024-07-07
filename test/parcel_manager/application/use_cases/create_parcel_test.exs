defmodule ParcelManager.Application.UseCases.CreateParcelTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.UseCases.CreateParcel
  alias ParcelManager.Infrastructure.Persistence.Schemas.Parcel

  describe "call/1" do
    test "returns error when unable to insert" do
      dto = build(:create_parcel_dto)

      log =
        capture_log(fn ->
          assert {:error, %Ecto.Changeset{}} = CreateParcel.call(dto)
        end)

      assert log =~
               "[info] #{CreateParcel}.call source_id=#{dto.source_id} destination_id=#{dto.destination_id}"
    end

    test "creates a parcel" do
      source = insert(:location)
      destination = insert(:location)
      dto = build(:create_parcel_dto, source_id: source.id, destination_id: destination.id)

      log =
        capture_log(fn ->
          assert {:ok, %Parcel{} = parcel} = CreateParcel.call(dto)

          refute is_nil(parcel.id)
          assert parcel.description == dto.description
          assert parcel.source_id == dto.source_id
          assert parcel.destination_id == dto.destination_id
        end)

      assert log =~
               "[info] #{CreateParcel}.call source_id=#{dto.source_id} destination_id=#{dto.destination_id}"
    end
  end
end

defmodule ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepositoryTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepository
  alias ParcelManager.Infrastructure.Persistence.Schemas.Parcel

  describe "create/1" do
    test "returns error when unable to insert" do
      attrs = %{}

      assert {:error, %Ecto.Changeset{}} = ParcelRepository.create(attrs)
    end

    test "creates a parcel" do
      source = insert(:location)
      destination = insert(:location)
      attrs = params_for(:parcel, source: source, current: source, destination: destination)

      assert {:ok, %Parcel{} = parcel} = ParcelRepository.create(attrs)
      assert parcel.description == attrs.description
      assert parcel.source_id == attrs.source_id
      assert parcel.current_id == attrs.source_id
      assert parcel.destination_id == attrs.destination_id
    end
  end

  describe "get/1" do
    test "returns nil when parcel is not found" do
      assert nil == ParcelRepository.get(Faker.UUID.v4())
    end

    test "reads a parcel selecting the data without transfers" do
      parcel = insert(:parcel)

      expected_result = %{
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
      }

      assert ParcelRepository.get(parcel.id) == expected_result
    end

    test "reads a parcel selecting the data with transfers" do
      location1 = insert(:location)
      location2 = insert(:location)
      parcel = insert(:parcel)

      transfer1 =
        insert(:transfer,
          parcel_id: parcel.id,
          parcel: parcel,
          location: location1,
          location_id: location1.id
        )

      transfer2 =
        insert(:transfer,
          parcel_id: parcel.id,
          parcel: parcel,
          location: location2,
          location_id: location2.id
        )

      expected_result = %{
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
        transfers: [
          %{
            location: %{
              id: location1.id,
              name: location1.name
            },
            location_id: location1.id,
            inserted_at: transfer1.inserted_at
          },
          %{
            location: %{
              id: location2.id,
              name: location2.name
            },
            location_id: location2.id,
            inserted_at: transfer2.inserted_at
          }
        ],
        destination_id: parcel.destination_id,
        destination: %{
          id: parcel.destination.id,
          name: parcel.destination.name
        }
      }

      assert ParcelRepository.get(parcel.id) == expected_result
    end
  end

  describe "update/2" do
    test "updates a parcel" do
      parcel = insert(:parcel)
      attrs = %{is_delivered: true, state: :delivered}

      refute parcel.is_delivered
      assert parcel.state == :in_transit
      assert {:ok, %Parcel{} = updated_parcel} = ParcelRepository.update(parcel, attrs)
      assert updated_parcel.is_delivered
      assert updated_parcel.state == :delivered
    end

    test "returns error when unable to update" do
      parcel = insert(:parcel)
      attrs = %{state: :invalid}

      assert {:error, %Ecto.Changeset{}} = ParcelRepository.update(parcel, attrs)
    end
  end
end

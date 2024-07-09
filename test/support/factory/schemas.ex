defmodule ParcelManager.Factory.Schemas do
  @moduledoc false

  @spec __using__(Keyword.t()) :: Macro.t()
  defmacro __using__(_opts) do
    quote do
      alias ParcelManager.Infrastructure.Persistence.Schemas

      @spec location_factory :: Schemas.Location.t()
      def location_factory do
        %Schemas.Location{id: Faker.UUID.v4(), name: Faker.Address.PtBr.city()}
      end

      @spec parcel_factory :: Schemas.Parcel.t()
      def parcel_factory do
        source = build(:location)
        current = build(:location)
        destination = build(:location)

        %Schemas.Parcel{
          id: Faker.UUID.v4(),
          description: Faker.Lorem.sentence(),
          source: source,
          state: :in_transit,
          current: current,
          is_delivered: false,
          destination: destination
        }
      end

      @spec transfer_factory :: Schemas.Transfer.t()
      def transfer_factory do
        location = build(:location)
        parcel = build(:parcel)

        %Schemas.Transfer{
          id: Faker.UUID.v4(),
          location: location,
          parcel: parcel
        }
      end
    end
  end
end

defmodule ParcelManager.Factory.Dtos do
  @moduledoc false

  @spec __using__(Keyword.t()) :: Macro.t()
  defmacro __using__(_opts) do
    quote do
      alias ParcelManager.Application.Dtos

      @spec create_parcel_dto_factory :: Dtos.CreateParcel.t()
      def create_parcel_dto_factory do
        %Dtos.CreateParcel{
          description: Faker.Lorem.sentence(),
          source_id: Faker.UUID.v4(),
          destination_id: Faker.UUID.v4()
        }
      end

      @spec get_parcel_dto_factory :: Dtos.GetParcel.t()
      def get_parcel_dto_factory do
        %Dtos.GetParcel{parcel_id: Faker.UUID.v4()}
      end

      @spec get_location_dto_factory :: Dtos.GetLocation.t()
      def get_location_dto_factory do
        %Dtos.GetLocation{location_id: Faker.UUID.v4()}
      end

      @spec transfer_parcel_dto_factory :: Dtos.TransferParcel.t()
      def transfer_parcel_dto_factory do
        %Dtos.TransferParcel{
          parcel_id: Faker.UUID.v4(),
          transfer_location_id: Faker.UUID.v4()
        }
      end

      @spec cancel_parcel_dto_factory :: Dtos.CancelParcel.t()
      def cancel_parcel_dto_factory do
        %Dtos.CancelParcel{
          parcel_id: Faker.UUID.v4(),
          reason: Faker.Lorem.word()
        }
      end
    end
  end
end

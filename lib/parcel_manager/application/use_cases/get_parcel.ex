defmodule ParcelManager.Application.UseCases.GetParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  @type use_case_output :: {:ok, Schemas.Parcel.t()} | {:error, :parcel_not_found}

  @spec call(dto :: Dtos.GetParcel.t()) :: use_case_output()
  def call(%Dtos.GetParcel{} = dto) do
    Logger.info("#{__MODULE__}.call parcel_id=#{dto.parcel_id}")

    case Entities.Parcel.get(dto.parcel_id) do
      nil -> {:error, :parcel_not_found}
      parcel -> {:ok, parcel}
    end
  end
end

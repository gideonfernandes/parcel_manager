defmodule ParcelManager.Application.UseCases.GetParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  @type use_case_output :: {:ok, map()} | {:error, Error.t()}

  @spec call(dto :: Dtos.GetParcel.t()) :: use_case_output()
  def call(%Dtos.GetParcel{} = dto) do
    Logger.info("#{__MODULE__}.call parcel_id=#{dto.parcel_id}")

    dto.parcel_id
    |> Entities.Parcel.get()
    |> handle_result()
  end

  defp handle_result(nil) do
    {:error, Error.build(:not_found, "parcel not found")}
  end

  defp handle_result(parcel) do
    {:ok, parcel}
  end
end

defmodule ParcelManager.Application.UseCases.CreateParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  @type use_case_output :: {:ok, Schemas.Parcel.t()} | {:error, Ecto.Changeset.t()}

  @spec call(dto :: Dtos.CreateParcel.t()) :: use_case_output()
  def call(%Dtos.CreateParcel{} = dto) do
    Logger.info(
      "#{__MODULE__}.call source_id=#{dto.source_id} destination_id=#{dto.destination_id}"
    )

    dto
    |> Map.from_struct()
    |> Entities.Parcel.create()
  end
end

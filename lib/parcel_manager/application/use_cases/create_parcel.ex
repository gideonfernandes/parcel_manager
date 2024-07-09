defmodule ParcelManager.Application.UseCases.CreateParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  alias ParcelManager.Infrastructure.Persistence.Schemas

  @type use_case_output :: {:ok, Schemas.Parcel.t()} | {:error, Error.t()}

  @spec call(dto :: Dtos.CreateParcel.t()) :: use_case_output()
  def call(%Dtos.CreateParcel{} = dto) do
    Logger.info(
      "#{__MODULE__}.call source_id=#{dto.source_id} destination_id=#{dto.destination_id}"
    )

    dto
    |> Map.from_struct()
    |> Map.put(:current_id, dto.source_id)
    |> Entities.Parcel.create()
    |> handle_result()
  end

  defp handle_result({:ok, parcel}), do: {:ok, parcel}

  defp handle_result({:error, %Ecto.Changeset{} = changeset}) do
    {:error, Error.build(:bad_request, changeset)}
  end
end

defmodule ParcelManager.Application.UseCases.GetLocation do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  @type use_case_output :: {:ok, map()} | {:error, Error.t()}

  @spec call(dto :: Dtos.GetLocation.t()) :: use_case_output()
  def call(%Dtos.GetLocation{} = dto) do
    Logger.info("#{__MODULE__}.call location_id=#{dto.location_id}")

    dto.location_id
    |> Entities.Location.get()
    |> handle_result()
  end

  defp handle_result(nil) do
    {:error, Error.build(:not_found, "location not found")}
  end

  defp handle_result(location) do
    {:ok, location}
  end
end

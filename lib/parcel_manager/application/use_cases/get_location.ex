defmodule ParcelManager.Application.UseCases.GetLocation do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  @type use_case_output :: {:ok, Schemas.Location.t()} | {:error, :location_not_found}

  @spec call(dto :: Dtos.GetLocation.t()) :: use_case_output()
  def call(%Dtos.GetLocation{} = dto) do
    Logger.info("#{__MODULE__}.call location_id=#{dto.location_id}")

    case Entity.Location.get(dto.location_id) do
      nil -> {:error, :location_not_found}
      location -> {:ok, location}
    end
  end
end

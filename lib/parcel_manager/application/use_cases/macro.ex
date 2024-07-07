defmodule ParcelManager.Application.UseCases.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      require Logger

      alias ParcelManager.Application.Dtos
      alias ParcelManager.Application.Error
      alias ParcelManager.Domain.Aggregates
      alias ParcelManager.Domain.Entities
    end
  end
end

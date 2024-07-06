defmodule ParcelManager.Application.UseCases.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      require Logger

      alias ParcelManager.Application.Dtos
      alias ParcelManager.Application.Error
      alias ParcelManager.Domain.Entity
    end
  end
end

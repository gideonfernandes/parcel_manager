defmodule ParcelManager.Domain.Aggregates.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias ParcelManager.Domain.Entities
      alias ParcelManager.Infrastructure.Persistence.Schema
      alias ParcelManager.Infrastructure.Persistence.Repositories
    end
  end
end

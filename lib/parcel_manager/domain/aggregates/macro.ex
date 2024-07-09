defmodule ParcelManager.Domain.Aggregates.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias ParcelManager.Domain.Entities
      alias ParcelManager.Infrastructure.Persistence.Repositories
      alias ParcelManager.Infrastructure.Persistence.Schemas
    end
  end
end

defmodule ParcelManager.Domain.Entity.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias ParcelManager.Infrastructure.Persistence.Schemas
      alias ParcelManager.Infrastructure.Persistence.Repositories
    end
  end
end
defmodule ParcelManager.Infrastructure.Persistence.Queries.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query

      alias ParcelManager.Infrastructure.Persistence.Queries
      alias ParcelManager.Infrastructure.Persistence.Schemas
    end
  end
end

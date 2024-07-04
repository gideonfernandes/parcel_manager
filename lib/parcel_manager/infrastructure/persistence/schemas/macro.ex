defmodule ParcelManager.Infrastructure.Persistence.Schemas.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      alias ParcelManager.Infrastructure.Persistence.Schemas

      @primary_key {:id, Ecto.UUID, autogenerate: true}
      @foreign_key_type Ecto.UUID
    end
  end
end

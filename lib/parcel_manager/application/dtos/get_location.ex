defmodule ParcelManager.Application.Dtos.GetLocation do
  @moduledoc false

  use ParcelManager.Application.Dtos.Macro

  @required ~w/location_id/a
  @optional ~w//a

  @type t :: %__MODULE__{
          location_id: Ecto.UUID.t()
        }

  embedded_schema do
    field(:location_id, Ecto.UUID)
  end

  @spec changeset(schema :: Ecto.Schema.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end

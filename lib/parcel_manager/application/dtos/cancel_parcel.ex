defmodule ParcelManager.Application.Dtos.CancelParcel do
  @moduledoc false

  use ParcelManager.Application.Dtos.Macro

  @required ~w/parcel_id reason/a
  @optional ~w//a

  @type t :: %__MODULE__{
          parcel_id: Ecto.UUID.t(),
          reason: String.t()
        }

  embedded_schema do
    field(:parcel_id, Ecto.UUID)
    field(:reason, :string)
  end

  @spec changeset(schema :: Ecto.Schema.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end

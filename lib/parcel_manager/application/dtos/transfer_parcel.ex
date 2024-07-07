defmodule ParcelManager.Application.Dtos.TransferParcel do
  @moduledoc false

  use ParcelManager.Application.Dtos.Macro

  @required ~w/parcel_id transfer_location_id/a
  @optional ~w//a

  @type t :: %__MODULE__{
          parcel_id: Ecto.UUID.t(),
          transfer_location_id: Ecto.UUID.t()
        }

  embedded_schema do
    field(:parcel_id, Ecto.UUID)
    field(:transfer_location_id, Ecto.UUID)
  end

  @spec changeset(struct :: Ecto.Schema.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end

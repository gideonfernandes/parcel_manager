defmodule ParcelManager.Application.Dtos.GetParcel do
  @moduledoc false

  use ParcelManager.Application.Dtos.Macro

  @required ~w/parcel_id/a
  @optional ~w//a

  @type t :: %__MODULE__{
          parcel_id: Ecto.UUID.t()
        }

  embedded_schema do
    field(:parcel_id, Ecto.UUID)
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end

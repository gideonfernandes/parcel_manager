defmodule ParcelManager.Infrastructure.Persistence.Schemas.Transfer do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Schemas.Macro

  @required ~w/parcel_id location_id/a
  @optional ~w//a

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          location_id: Ecto.UUID.t(),
          location: Schemas.Location.t() | Ecto.Association.NotLoaded.t(),
          parcel_id: Ecto.UUID.t(),
          parcel: Schemas.Parcel.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t()
        }

  schema "transfers" do
    belongs_to(:location, Schemas.Location)
    belongs_to(:parcel, Schemas.Parcel)

    timestamps(updated_at: false)
  end

  @spec changeset(struct :: t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required)
    |> validate_required(@required ++ @optional)
    |> foreign_key_constraint(:parcel_id)
    |> foreign_key_constraint(:location_id)
  end
end

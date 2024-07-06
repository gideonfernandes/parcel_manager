defmodule ParcelManager.Infrastructure.Persistence.Schemas.Location do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Schemas.Macro

  @required ~w/name/a
  @optional ~w//a

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          source_parcels: [Schemas.Parcel.t()] | Ecto.Association.NotLoaded.t(),
          destination_parcels: [Schemas.Parcel.t()] | Ecto.Association.NotLoaded.t(),
          transfers: [Schemas.Transfer.t()] | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "locations" do
    field(:name, :string)

    has_many(:source_parcels, Schemas.Parcel,
      foreign_key: :source_id,
      where: [state: :pending]
    )

    has_many(:destination_parcels, Schemas.Parcel,
      foreign_key: :destination_id,
      where: [state: :delivered]
    )

    has_many(:transfers, Schemas.Transfer, foreign_key: :location_id)

    timestamps()
  end

  @spec changeset(struct :: t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end

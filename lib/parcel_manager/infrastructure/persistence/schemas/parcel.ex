defmodule ParcelManager.Infrastructure.Persistence.Schemas.Parcel do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Schemas.Macro

  @required ~w/description source_id destination_id/a
  @optional ~w/is_delivered state reason/a
  @valid_states ~w/pending canceled in_transit delivered/a

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          description: String.t(),
          source_id: Ecto.UUID.t(),
          source: Schemas.Location.t() | Ecto.Association.NotLoaded.t(),
          destination_id: Ecto.UUID.t(),
          destination: Schemas.Location.t() | Ecto.Association.NotLoaded.t(),
          transfers: [Schemas.Transfer.t()] | Ecto.Association.NotLoaded.t(),
          is_delivered: boolean(),
          state: atom(),
          reason: String.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "parcels" do
    field(:description, :string)
    field(:is_delivered, :boolean, default: false)
    field(:state, Ecto.Enum, values: @valid_states)
    field(:reason, :string)

    belongs_to(:source, Schemas.Location)
    belongs_to(:destination, Schemas.Location)
    has_many(:transfers, Schemas.Transfer)

    timestamps()
  end

  @spec changeset(struct :: t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_inclusion(:state, @valid_states)
    |> foreign_key_constraint(:source_id)
    |> foreign_key_constraint(:destination_id)
  end
end

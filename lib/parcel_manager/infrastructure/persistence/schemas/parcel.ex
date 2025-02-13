defmodule ParcelManager.Infrastructure.Persistence.Schemas.Parcel do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Schemas.Macro

  @required ~w/description source_id current_id destination_id/a
  @optional ~w/is_delivered state reason/a
  @valid_states ~w/pending canceled in_transit delivered/a

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          description: String.t(),
          source: Schemas.Location.t() | Ecto.Association.NotLoaded.t(),
          current: Schemas.Location.t() | Ecto.Association.NotLoaded.t(),
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
    field(:state, Ecto.Enum, values: @valid_states)
    field(:reason, :string)

    # Apesar de podermos utilizar o state para saber se o pacote foi entregue,
    # optei por manter esse campo dado que é um campo obrigatório na descrição do desafio.
    field(:is_delivered, :boolean, default: false)

    belongs_to(:source, Schemas.Location)
    belongs_to(:current, Schemas.Location)
    belongs_to(:destination, Schemas.Location)
    has_many(:transfers, Schemas.Transfer)

    timestamps()
  end

  @spec changeset(schema :: Ecto.Schema.t(), attrs :: map()) :: Changeset.t()
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_inclusion(:state, @valid_states)
    |> validate_location_distinction()
    |> validate_cancellation()
    |> foreign_key_constraint(:source_id)
    |> foreign_key_constraint(:current_id)
    |> foreign_key_constraint(:destination_id)
  end

  defp validate_location_distinction(%Changeset{valid?: true} = changeset) do
    Changeset.validate_change(
      changeset,
      :destination_id,
      &do_validate_location_distinction(changeset, &1, &2)
    )
  end

  defp validate_location_distinction(changeset), do: changeset

  defp do_validate_location_distinction(changeset, field, value) do
    if value == Changeset.get_change(changeset, :source_id) do
      [{field, "must be different from source_id"}]
    else
      []
    end
  end

  defp validate_cancellation(%Changeset{valid?: true} = changeset) do
    changeset
    |> Changeset.get_change(:state)
    |> then(&do_validate_cancellation(changeset, &1))
  end

  defp validate_cancellation(changeset), do: changeset

  defp do_validate_cancellation(changeset, :canceled), do: validate_required(changeset, :reason)
  defp do_validate_cancellation(changeset, _state), do: changeset
end

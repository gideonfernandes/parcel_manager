defmodule ParcelManager.Application.Dtos.CreateParcel do
  @moduledoc false

  use ParcelManager.Application.Dtos.Macro

  @required ~w/description source_id destination_id/a
  @optional ~w//a

  @type t :: %__MODULE__{
          description: String.t(),
          source_id: Ecto.UUID.t(),
          destination_id: Ecto.UUID.t()
        }

  embedded_schema do
    field(:description, :string)
    field(:source_id, Ecto.UUID)
    field(:destination_id, Ecto.UUID)
  end

  @spec changeset(struct :: Ecto.Schema.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end

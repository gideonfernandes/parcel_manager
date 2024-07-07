defmodule ParcelManager.Application.Error do
  @moduledoc false

  @type result :: Ecto.Changeset.t() | String.t()

  @type t :: %__MODULE__{
          status: atom(),
          result: result()
        }

  @keys ~w/result status/a

  @enforce_keys @keys

  defstruct @keys

  @spec build(status :: atom(), result :: result()) :: t()
  def build(status, result), do: %__MODULE__{status: status, result: result}
end

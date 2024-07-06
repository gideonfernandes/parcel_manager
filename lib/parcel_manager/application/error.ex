defmodule ParcelManager.Application.Error do
  @moduledoc false

  @keys ~w/result status/a

  @enforce_keys @keys

  defstruct @keys

  @spec build(status :: atom(), result :: any()) :: %__MODULE__{status: atom(), result: any()}
  def build(status, result), do: %__MODULE__{status: status, result: result}
end

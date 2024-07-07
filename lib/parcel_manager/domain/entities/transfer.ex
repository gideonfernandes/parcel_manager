defmodule ParcelManager.Domain.Entities.Transfer do
  @moduledoc false

  use ParcelManager.Domain.Entities.Macro

  defdelegate create(attrs), to: Repositories.TransferRepository, as: :create
end

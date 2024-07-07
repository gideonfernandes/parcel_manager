defmodule ParcelManager.Infrastructure.Persistence.Repositories.TransferRepository do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Repositories.Macro

  @spec create(attrs :: map) :: {:ok, Schemas.Transfer.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Schemas.Transfer{}
    |> Schemas.Transfer.changeset(attrs)
    |> Repo.insert(telemetry_options: [name: :create_transfer])
  end
end

defmodule ParcelManager.Infrastructure.Persistence.Repositories.ParcelRepository do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Repositories.Macro

  @spec create(attrs :: map) :: {:ok, Schemas.Parcel.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Schemas.Parcel{}
    |> Schemas.Parcel.changeset(attrs)
    |> Repo.insert(telemetry_options: [name: :create_parcel])
  end
end

defmodule ParcelManager.Infrastructure.Persistence.Queries.Location do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Queries.Macro

  @spec by_id(location_id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def by_id(location_id) do
    where(Schemas.Location, [l], l.id == ^location_id)
  end

  @spec by_id(query :: Ecto.Query.t(), location_id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def by_id(query, location_id) do
    where(query, [location: l], l.id == ^location_id)
  end
end

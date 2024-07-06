defmodule ParcelManager.Infrastructure.Persistence.Queries.Parcel do
  @moduledoc false

  use ParcelManager.Infrastructure.Persistence.Queries.Macro

  @spec by_id(query :: Ecto.Query.t(), parcel_id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def by_id(query, parcel_id) do
    where(query, [parcel: p], p.id == ^parcel_id)
  end

  @spec with_source(Ecto.Query.t()) :: Ecto.Query.t()
  def with_source(query) do
    join(query, :inner, [parcel: p], s in assoc(p, :source), as: :source)
  end

  @spec with_destination(Ecto.Query.t()) :: Ecto.Query.t()
  def with_destination(query) do
    join(query, :inner, [parcel: p], d in assoc(p, :destination), as: :destination)
  end
end

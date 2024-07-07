defmodule ParcelManager.Domain.Entities.Location do
  @moduledoc false

  use ParcelManager.Domain.Entities.Macro

  defdelegate get(attrs), to: Repositories.LocationRepository, as: :get
  defdelegate by_id(location_id), to: Queries.Location, as: :by_id
end

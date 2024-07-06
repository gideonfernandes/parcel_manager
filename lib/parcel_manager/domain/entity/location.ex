defmodule ParcelManager.Domain.Entity.Location do
  @moduledoc false

  use ParcelManager.Domain.Entity.Macro

  defdelegate get(attrs), to: Repositories.LocationRepository, as: :get
end

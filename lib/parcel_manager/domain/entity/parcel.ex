defmodule ParcelManager.Domain.Entity.Parcel do
  @moduledoc false

  use ParcelManager.Domain.Entity.Macro

  defdelegate create(attrs), to: Repositories.ParcelRepository, as: :create
  defdelegate get(attrs), to: Repositories.ParcelRepository, as: :get
end

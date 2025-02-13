defmodule ParcelManager.Factory do
  @moduledoc """
  Support module responsible for providing factories to facilitate
  data persistence in tests.
  """

  use ExMachina.Ecto, repo: ParcelManager.Infrastructure.Persistence.Repo
  use ParcelManager.Factory.Dtos
  use ParcelManager.Factory.Schemas
end

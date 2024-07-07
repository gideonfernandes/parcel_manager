defmodule ParcelManager.Infrastructure.Mailer.Ports.Sender do
  @moduledoc """
  Defines the behaviour for an email delivery system.
  """

  @callback call(message :: map()) :: {:ok, any()} | {:error, any()}

  @implementation Application.compile_env!(:parcel_manager, __MODULE__)[:adapter]

  defdelegate call(message), to: @implementation
end

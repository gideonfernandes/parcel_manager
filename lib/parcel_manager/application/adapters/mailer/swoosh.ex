defmodule ParcelManager.Application.Adapters.Mailer.Swoosh do
  @moduledoc """
  This module serves as a the mail delivery service interface.
  It uses `Swoosh` to send emails.
  """

  use Swoosh.Mailer, otp_app: :parcel_manager

  @behaviour ParcelManager.Infrastructure.Mailer.Ports.Sender

  @impl true
  def call(_message), do: {:ok, :email_successfully_sent!}
end

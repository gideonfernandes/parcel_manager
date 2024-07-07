defmodule ParcelManager.Infrastructure.Mailer.Workers.SenderWorker do
  @moduledoc false

  use Oban.Worker, queue: :emails, max_attempts: 3, priority: 1

  alias ParcelManager.Infrastructure.Mailer.Ports.Sender

  @impl true
  def perform(%Oban.Job{args: args}), do: Sender.call(args)
end

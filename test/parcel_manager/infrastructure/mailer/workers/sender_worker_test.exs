defmodule ParcelManager.Infrastructure.Mailer.Workers.SenderWorkerTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker

  describe "perform/1" do
    test "calls sender worker" do
      args = %{"message" => "Hello, World!"}
      expected_result = {:ok, :email_successfully_sent!}

      assert perform_job(SenderWorker, args) == expected_result
    end
  end
end

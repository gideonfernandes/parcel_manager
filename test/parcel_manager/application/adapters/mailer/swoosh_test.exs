defmodule ParcelManager.Application.Adapters.Mailer.SwooshTest do
  @moduledoc false

  use ParcelManager.DataCase, async: true

  alias ParcelManager.Application.Adapters.Mailer.Swoosh

  describe "call/1" do
    test "sends email" do
      args = %{"message" => "Hello, World!"}
      expected_result = {:ok, :email_successfully_sent!}

      assert Swoosh.call(args) == expected_result
    end
  end
end

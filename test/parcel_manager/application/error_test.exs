defmodule ParcelManager.Application.ErrorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ParcelManager.Application.Error

  describe "build/2" do
    test "builds an error" do
      expected_result = %Error{status: :bad_request, result: :error}

      assert Error.build(:bad_request, :error) == expected_result
    end
  end
end

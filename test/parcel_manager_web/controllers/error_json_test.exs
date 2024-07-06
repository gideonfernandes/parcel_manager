defmodule ParcelManagerWeb.ErrorJSONTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ParcelManagerWeb.ErrorJSON

  test "renders error.json" do
    attrs = %{result: "some error"}
    expected_result = %{reason: "some error"}

    assert ErrorJSON.render("error.json", attrs) == expected_result
  end
end

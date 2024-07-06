defmodule ParcelManagerWeb.ParcelJSONTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ParcelManagerWeb.ParcelJSON

  test "renders created.json" do
    attrs = %{parcel: %{id: Faker.UUID.v4()}}
    expected_result = %{data: %{id: attrs.parcel.id}}

    assert ParcelJSON.render("created.json", attrs) == expected_result
  end
end

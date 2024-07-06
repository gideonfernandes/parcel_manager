defmodule ParcelManagerWeb.ParcelJSON do
  @moduledoc false

  def render("created.json", %{parcel: parcel}) do
    %{data: %{id: parcel.id}}
  end
end

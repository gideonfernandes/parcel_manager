defmodule ParcelManagerWeb.LocationJSON do
  @moduledoc false

  def render("show.json", %{location: location}) do
    %{data: parse_location(location)}
  end

  defp parse_location(location) do
    %{
      id: location.id,
      name: location.name,
      parcels: location.current_parcels
    }
  end
end

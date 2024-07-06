defmodule ParcelManagerWeb.ParcelJSON do
  @moduledoc false

  def render("created.json", %{parcel: parcel}) do
    %{data: %{id: parcel.id}}
  end

  def render("show.json", %{parcel: parcel}) do
    %{data: parse_parcel(parcel)}
  end

  defp parse_parcel(parcel) do
    source = %{id: parcel.source.id, name: parcel.source.name}

    %{
      id: parcel.id,
      description: parcel.description,
      is_delivered: parcel.is_delivered,
      state: parcel.state,
      reason: parcel.reason,
      source: source,
      locations: parse_locations(source, parcel.transfers),
      destination: %{
        id: parcel.destination.id,
        name: parcel.destination.name
      }
    }
  end

  defp parse_locations(source, transfers) do
    [source | transfers |> Enum.sort_by(& &1.inserted_at) |> Enum.map(&parse_location/1)]
  end

  defp parse_location(%{location: location}) do
    %{id: location.id, name: location.name}
  end
end

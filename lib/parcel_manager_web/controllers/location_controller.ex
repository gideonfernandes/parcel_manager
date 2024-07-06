defmodule ParcelManagerWeb.LocationController do
  @moduledoc false

  use ParcelManagerWeb, :controller

  alias ParcelManagerWeb.FallbackController

  action_fallback FallbackController

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, params) do
    with {:ok, location} <- ParcelManager.get_location(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", location: location)
    end
  end
end

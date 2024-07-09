defmodule ParcelManagerWeb.LocationController do
  @moduledoc false

  use ParcelManagerWeb, :controller

  alias ParcelManager.Application.Error
  alias ParcelManagerWeb.FallbackController

  action_fallback FallbackController

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, Error.t()}
  def show(conn, params) do
    with {:ok, location} <- ParcelManager.get_location(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", location: location)
    end
  end
end

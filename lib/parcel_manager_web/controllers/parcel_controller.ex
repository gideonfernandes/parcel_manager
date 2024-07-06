defmodule ParcelManagerWeb.ParcelController do
  @moduledoc false

  use ParcelManagerWeb, :controller

  alias ParcelManagerWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, parcel} <- ParcelManager.create_parcel(params) do
      conn
      |> put_status(:created)
      |> render("created.json", parcel: parcel)
    end
  end
end

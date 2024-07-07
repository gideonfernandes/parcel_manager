defmodule ParcelManagerWeb.ParcelController do
  @moduledoc false

  use ParcelManagerWeb, :controller

  alias ParcelManagerWeb.FallbackController

  action_fallback FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, parcel} <- ParcelManager.create_parcel(params) do
      conn
      |> put_status(:created)
      |> render("created.json", parcel: parcel)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, params) do
    with {:ok, parcel} <- ParcelManager.get_parcel(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", parcel: parcel)
    end
  end

  @spec transfer(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def transfer(conn, params) do
    with {:ok, result} <- ParcelManager.transfer_parcel(params) do
      conn
      |> put_status(:created)
      |> render("transfer.json", transfer: result.transfer_parcel.transfer)
    end
  end
end

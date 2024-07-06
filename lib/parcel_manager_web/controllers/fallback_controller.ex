defmodule ParcelManagerWeb.FallbackController do
  @moduledoc false

  use ParcelManagerWeb, :controller

  alias ParcelManager.Application.Error
  alias ParcelManagerWeb.ErrorJSON

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorJSON)
    |> render("error.json", result: result)
  end
end

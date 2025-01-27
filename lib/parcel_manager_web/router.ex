defmodule ParcelManagerWeb.Router do
  use ParcelManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParcelManagerWeb do
    pipe_through :api

    # Na minha perspectiva faria mais sentido utilizar uma rota patch.
    post "/parcel/:parcel_id/transfer", ParcelController, :transfer

    post "/parcel", ParcelController, :create
    get "/parcel/:parcel_id", ParcelController, :show
    get "/location/:location_id", LocationController, :show
    patch "/parcel/:parcel_id/cancel", ParcelController, :cancel
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:parcel_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ParcelManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
